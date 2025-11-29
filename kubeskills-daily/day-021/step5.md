## Step 5: List all finalizers on the namespace

```bash
kubectl get namespace stuck-namespace -o jsonpath='{.metadata.finalizers}'
echo ""
```{{exec}}

See which finalizers are blocking deletion.
