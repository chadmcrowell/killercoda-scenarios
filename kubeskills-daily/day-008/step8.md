## Step 8: Test reclaim policies

```bash
DEFAULT_PROVISIONER=$(kubectl get storageclass -o jsonpath='{.items[0].provisioner}')

cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: retain-storage
provisioner: $DEFAULT_PROVISIONER
reclaimPolicy: Retain
volumeBindingMode: Immediate
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: retain-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: retain-storage
  resources:
    requests:
      storage: 1Gi
EOF
```{{exec}}

```bash
kubectl get pvc retain-pvc -w
```{{exec}}

```bash
kubectl delete pvc retain-pvc
```{{exec}}

```bash
kubectl get pv
```{{exec}}

After deleting the PVC, the backing PV moves to `Released` instead of disappearing—data remains but the PV needs manual cleanup before reuse.
