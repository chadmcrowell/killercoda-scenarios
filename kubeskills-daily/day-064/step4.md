## Step 4: Request volume with broken StorageClass

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: broken-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: broken-storage
  resources:
    requests:
      storage: 1Gi
EOF

# Check status (stuck Pending)
sleep 5
kubectl get pvc broken-pvc
kubectl describe pvc broken-pvc | grep -A 10 "Events:"
```{{exec}}

Confirm the PVC is Pending with a provisioner error.
