## Step 8: Test PVC quota

```bash
# Create PVCs up to limit
for i in 1 2; do
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-$i
  namespace: quota-test
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF
done

# Try to create 3rd PVC (exceeds quota of 2)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-3
  namespace: quota-test
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF

sleep 5
kubectl get pvc -n quota-test
kubectl get events -n quota-test | grep pvc-3
```{{exec}}

See how PVC quotas block extra claims.
