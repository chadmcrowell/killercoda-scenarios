## Step 7: Test PVC with protection finalizer

```bash
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
```{{exec}}

```bash
kubectl get pvc test-pvc -o jsonpath='{.metadata.finalizers}'
echo ""
```{{exec}}

PVC shows `kubernetes.io/pvc-protection` finalizer by default.
