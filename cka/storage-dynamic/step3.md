With `local-path-retain` set as the default StorageClass, deploy a workload that uses dynamic provisioning without explicitly naming a StorageClass.

1. Create a `PersistentVolumeClaim` named `retain-pvc` in namespace `default` that:
   - Requests `256Mi`
   - Uses access mode `ReadWriteOnce`
   - Does **not** explicitly set a `storageClassName` (it should pick up the new default)

2. Create a `Pod` named `retain-pod` using image `busybox:1.28` with:
   - Command: `["sh", "-c", "echo retained > /data/output.txt && sleep 3600"]`
   - `retain-pvc` mounted at `/data`

After the pod is running, verify the output and then observe the `Retain` policy in action by deleting the PVC.

<br>
<details><summary>Solution</summary>
<br>

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: retain-pvc
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 256Mi
EOF
```{{exec}}

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: retain-pod
  namespace: default
spec:
  containers:
  - name: busybox
    image: busybox:1.28
    command: ["sh", "-c", "echo retained > /data/output.txt && sleep 3600"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: retain-pvc
EOF
```{{exec}}

Wait for the pod to be running:

```bash
kubectl get pod retain-pod -w
```{{exec}}

Verify the PVC is bound and the file was written:

```bash
kubectl get pvc retain-pvc
```{{exec}}

```bash
kubectl exec retain-pod -- cat /data/output.txt
```{{exec}}

Expected output: `retained`

Now delete the PVC and observe that the PV moves to `Released` rather than being deleted:

```bash
kubectl delete pvc retain-pvc
```{{exec}}

```bash
kubectl get pv
```{{exec}}

The PV status should be `Released`, not removed. This is the `Retain` policy in action — the data and volume persist even after the claim is deleted.

</details>
