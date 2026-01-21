## Step 6: Test volume with insufficient capacity

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: huge-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Ti  # Unrealistic size
EOF

kubectl get pvc huge-pvc
kubectl describe pvc huge-pvc | grep -A 5 "Events:"
```{{exec}}

Request an oversized volume and check for capacity errors.
