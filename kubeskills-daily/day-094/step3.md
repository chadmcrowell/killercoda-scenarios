# Step 3 — Apply the Fix

Two paths resolve this. Option A creates the missing `fast-ssd` StorageClass backed by the available provisioner — the fix is invisible to the application team and requires no changes to the PVC. Option B deletes and recreates the PVC pointing to `local-path` directly. Choose Option A in production when many workloads reference the same class name; choose Option B when you want to normalize the class names across your cluster.

## Option A — Create the Missing StorageClass

Create a `fast-ssd` StorageClass backed by the `rancher.io/local-path` provisioner that is already running on this cluster:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: rancher.io/local-path
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: false
EOF
```{{exec}}

Confirm the new StorageClass exists alongside the default:

```bash
kubectl get storageclass
```{{exec}}

```text
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  15m
fast-ssd               rancher.io/local-path   Delete          WaitForFirstConsumer   false                  5s
```

Both classes use the same provisioner. The `fast-ssd` name now resolves, and the `persistentvolume-controller` can process the pending claim.

## Watch the PVC and Pod Self-Heal

Because `fast-ssd` uses `WaitForFirstConsumer`, the volume is not provisioned until the pod is scheduled to a node. The provisioner controller will retry the PVC now that the StorageClass exists, but the actual volume creation happens when the scheduler places the pod. Watch everything converge:

```bash
kubectl get pvc,pods -n data-tier -w
```{{exec}}

Press `Ctrl+C` when you see the PVC reach `Bound` and the pod reach `Running`:

```text
NAME                          STATUS    VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/postgres-data   Bound     pvc-3e8a1f2b-...                  1Gi        RWO            fast-ssd       3m

NAME                             READY   STATUS    RESTARTS   AGE
pod/postgres-6d8f7c9b4d-xk2p9    1/1     Running   0          3m
```

The PVC transitioned from `Pending` to `Bound` and the pod moved from `Pending` to `Running` without any changes to the Deployment or the PVC spec. The StorageClass creation was the only intervention needed.

Confirm a PersistentVolume was automatically created and bound:

```bash
kubectl get pv
```{{exec}}

```text
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS   AGE
pvc-3e8a1f2b-...                           1Gi        RWO            Delete           Bound    data-tier/postgres-data      fast-ssd       30s
```

The dynamic provisioner created the PV on the node where the pod was scheduled. The PVC and PV are now bound to each other with a 1:1 relationship.

---

## Option B — Recreate the PVC with the Correct StorageClass Name

If you want to align the PVC to the existing `local-path` class instead, you must delete and recreate the PVC — the `storageClassName` field is immutable after creation.

> **Warning:** Deleting a PVC with `reclaimPolicy: Delete` will also delete the bound PersistentVolume and any data stored on it once no pod is using it. In production, scale down the workload first.

Scale down the deployment to release the PVC:

```bash
kubectl scale deployment postgres -n data-tier --replicas=0
```{{exec}}

Delete the existing PVC:

```bash
kubectl delete pvc postgres-data -n data-tier
```{{exec}}

Recreate it pointing to `local-path`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-data
  namespace: data-tier
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: local-path
EOF
```{{exec}}

Scale the deployment back up:

```bash
kubectl scale deployment postgres -n data-tier --replicas=1
```{{exec}}

Watch the pod come up:

```bash
kubectl get pvc,pods -n data-tier -w
```{{exec}}

Press `Ctrl+C` when the PVC shows `Bound` and the pod shows `Running`.

---

## Final Verification

Confirm the database pod is running and the PVC is fully bound:

```bash
kubectl get pvc,pods -n data-tier
```{{exec}}

Verify the pod can write to the mounted volume:

```bash
kubectl exec -n data-tier deployment/postgres -- \
  psql -U postgres -c "SELECT version();"
```{{exec}}

```text
                                                 version
---------------------------------------------------------------------------------------------------------
 PostgreSQL 15.x on x86_64-pc-linux-gnu, compiled by gcc, version 12.x, 64-bit
(1 row)
```

PostgreSQL is running and accepting queries, which confirms the data directory on the mounted volume is writable.

---

## PVC Debugging Runbook

When a pod is stuck in Pending and you suspect storage:

```bash
# 1. Check what the pod is waiting for
kubectl describe pod -n <namespace> <pod-name>

# 2. Find the PVC status and events
kubectl describe pvc -n <namespace> <pvc-name>

# 3. List all StorageClasses in the cluster
kubectl get storageclass

# 4. Check the events namespace-wide for provisioner errors
kubectl get events -n <namespace> --sort-by='.lastTimestamp' | grep -i prov

# 5. Confirm which StorageClass the PVC is requesting
kubectl get pvc -n <namespace> <pvc-name> -o jsonpath='{.spec.storageClassName}'
```{{exec}}

If the PVC event shows `storageclass "X" not found`, the fix is one of: create the StorageClass, correct the name in the PVC (requires delete + recreate), or annotate an existing class as default and remove the explicit `storageClassName` from the PVC spec.
