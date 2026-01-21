## Step 13: Test volume expansion (if supported)

```bash
# Check if storage class allows expansion
kubectl get storageclass -o jsonpath='{range .items[*]}{.metadata.name}{"	"}{.allowVolumeExpansion}{"
"}{end}'

# Try to expand PVC
kubectl patch pvc test-pvc -p '{"spec":{"resources":{"requests":{"storage":"2Gi"}}}}'

# Check if expansion supported
kubectl describe pvc test-pvc | grep -i "expansion\|resize"
```{{exec}}

Attempt a PVC resize and check for expansion support.
