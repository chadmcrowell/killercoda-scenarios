## Step 8: Force remove finalizer

```bash
# Remove finalizer to allow deletion
kubectl patch webapp with-finalizer -p '{"metadata":{"finalizers":[]}}' --type=merge

# Now deletion completes
kubectl get webapp with-finalizer 2>&1 || echo "Deleted successfully"
```{{exec}}

Manually removing finalizers allows stuck resources to be deleted.
