## Step 11: Inspect deletion timestamp

```bash
kubectl get configmap controlled-resource -n finalizer-test -o jsonpath='{.metadata.deletionTimestamp}'
echo ""
```{{exec}}

Shows when deletion was requested even though the resource persists.
