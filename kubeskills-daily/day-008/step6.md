## Step 6: Test WaitForFirstConsumer binding mode

```bash
kubectl delete pod storage-app
kubectl delete pvc broken-pvc
```{{exec}}

```bash
DEFAULT_PROVISIONER=$(kubectl get storageclass -o jsonpath='{.items[0].provisioner}')

cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: delayed-binding
provisioner: $DEFAULT_PROVISIONER
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: delayed-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: delayed-binding
  resources:
    requests:
      storage: 1Gi
EOF
```{{exec}}

```bash
kubectl get pvc delayed-pvc
```{{exec}}

```bash
kubectl describe pvc delayed-pvc | grep -A 3 Events
```{{exec}}

PVC stays `Pending` by design with `WaitForFirstConsumer` until a pod needs it; events note it is waiting for a consumer.
