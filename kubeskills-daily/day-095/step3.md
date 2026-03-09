# Step 3 — Apply the Fix

Two approaches resolve this. Option A creates the missing `ssd-retain` StorageClass using the available provisioner — the PVC and Deployment need no changes, and the fix is transparent to the application team. Option B deletes and recreates the PVC pointing directly to `local-path`. Use Option A when you need the fix to be non-invasive or when multiple workloads reference the same class name. Use Option B when you want to normalize StorageClass names across the cluster and accept the brief downtime of a PVC recreation.

## Option A — Create the Missing StorageClass

Create a `ssd-retain` StorageClass backed by the `rancher.io/local-path` provisioner that is already running in this cluster. Because the original name implies a retain policy, set `reclaimPolicy: Retain` to match the intent of the original manifest:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ssd-retain
provisioner: rancher.io/local-path
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: false
EOF
```{{exec}}

Confirm both StorageClasses are now registered:

```bash
kubectl get storageclass
```{{exec}}

```text
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  15m
ssd-retain             rancher.io/local-path   Retain          WaitForFirstConsumer   false                  4s
```

The `ssd-retain` name now resolves. The `persistentvolume-controller` can process the pending claim.

## Watch the PVC and Pod Self-Heal

Because `ssd-retain` uses `WaitForFirstConsumer`, the volume is not provisioned until the scheduler places the pod on a node. The controller will retry the PVC immediately now that the StorageClass exists, but the actual PersistentVolume is created at scheduling time. Watch everything converge:

```bash
kubectl get pvc,pods -n dev-tools -w
```{{exec}}

Press `Ctrl+C` when the PVC reaches `Bound` and the pod reaches `Running`:

```text
NAME                                 STATUS    VOLUME                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/gitea-repos    Bound     pvc-a1b2c3d4-...           5Gi        RWO            ssd-retain     4m

NAME                         READY   STATUS    RESTARTS   AGE
pod/gitea-7d9f8c6b5-mnpq2    1/1     Running   0          4m
```

The PVC moved from `Pending` to `Bound` and the pod moved from `Pending` to `Running` without any changes to the Deployment or the PVC spec.

Confirm a PersistentVolume was dynamically provisioned and is now bound:

```bash
kubectl get pv
```{{exec}}

```text
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS   AGE
pvc-a1b2c3d4-...                           5Gi        RWO            Retain           Bound    dev-tools/gitea-repos      ssd-retain     45s
```

The PV uses `Retain` policy, which means if the PVC is deleted the PV and its data are preserved until manually cleaned up.

---

## Option B — Recreate the PVC with the Correct StorageClass Name

If you prefer to align the PVC directly to the existing `local-path` class, you must delete and recreate the PVC. The `storageClassName` field is immutable — you cannot patch it in place.

> **Warning:** Deleting a PVC while a pod is using it will leave the pod running until it restarts, at which point it will lose access to the volume. Always scale down the workload first.

Scale down the deployment to release the PVC:

```bash
kubectl scale deployment gitea -n dev-tools --replicas=0
```{{exec}}

Delete the existing PVC:

```bash
kubectl delete pvc gitea-repos -n dev-tools
```{{exec}}

Recreate it pointing to `local-path`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gitea-repos
  namespace: dev-tools
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: local-path
EOF
```{{exec}}

Scale the deployment back up:

```bash
kubectl scale deployment gitea -n dev-tools --replicas=1
```{{exec}}

Watch the pod come up:

```bash
kubectl get pvc,pods -n dev-tools -w
```{{exec}}

Press `Ctrl+C` when the PVC shows `Bound` and the pod shows `Running`.

---

## Final Verification

Confirm the pod is running and the PVC is fully bound:

```bash
kubectl get pvc,pods -n dev-tools
```{{exec}}

Verify the Gitea web interface is reachable inside the cluster:

```bash
kubectl exec -n dev-tools deployment/gitea -- wget -qO- http://localhost:3000/
```{{exec}}

A successful response confirms the Gitea process started and can write to the mounted volume.

---

## PVC Debugging Runbook

When a pod is stuck in `Pending` and you suspect storage:

```bash
# 1. Check what the pod is waiting for
kubectl describe pod -n <namespace> <pod-name>

# 2. Check PVC status and events
kubectl describe pvc -n <namespace> <pvc-name>

# 3. List all StorageClasses registered in the cluster
kubectl get storageclass

# 4. Check namespace-wide events for provisioner errors
kubectl get events -n <namespace> --sort-by='.lastTimestamp' | grep -i prov

# 5. Confirm the exact StorageClass name the PVC is requesting
kubectl get pvc -n <namespace> <pvc-name> -o jsonpath='{.spec.storageClassName}'
```

If the PVC event shows `storageclass "X" not found`, the fix is one of:

- **Create the StorageClass** — no changes needed to the PVC or Deployment
- **Recreate the PVC** with a corrected `storageClassName` (requires delete + recreate; `storageClassName` is immutable)
- **Remove the `storageClassName` field entirely** from the PVC to let the cluster default take over
