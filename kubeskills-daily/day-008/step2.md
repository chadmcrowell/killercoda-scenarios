## Step 2: Create a PVC with nonexistent StorageClass

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: broken-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: super-fast-nvme  # Doesn't exist!
  resources:
    requests:
      storage: 1Gi
EOF
```{{exec}}

```bash
kubectl get pvc broken-pvc
```{{exec}}

Status sits at `Pending`—there's no StorageClass to fulfill it, but Kubernetes doesn't loudly error.
