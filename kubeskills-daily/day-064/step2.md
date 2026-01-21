## Step 2: Test basic PVC creation

```bash
# Create PVC
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF

# Check status
kubectl get pvc test-pvc
kubectl describe pvc test-pvc
```{{exec}}

Create a PVC and verify binding behavior.
