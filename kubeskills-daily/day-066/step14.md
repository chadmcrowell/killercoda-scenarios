## Step 14: Monitor quota usage

```bash
# Get all quotas across namespaces
kubectl get resourcequota -A

# Detailed quota status
kubectl describe resourcequota -n quota-test
```{{exec}}

Review current quota usage across namespaces.
