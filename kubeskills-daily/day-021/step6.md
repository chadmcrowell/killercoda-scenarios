## Step 6: Remove finalizer to complete namespace deletion

```bash
kubectl patch namespace stuck-namespace -p '{"metadata":{"finalizers":[]}}' --type=merge
```{{exec}}

Namespace should delete immediately once finalizers are cleared.
