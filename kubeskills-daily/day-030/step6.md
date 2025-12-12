## Step 6: Watch for reconciliation trigger

```bash
# Get initial resource version
kubectl get webapp test-app -o jsonpath='{.metadata.resourceVersion}'
echo ""

# Update status without subresource (wrong)
kubectl patch webapp test-app --type=merge -p '{"status":{"phase":"Ready"}}'

# Check resource version again
kubectl get webapp test-app -o jsonpath='{.metadata.resourceVersion}'
echo ""
```{{exec}}

Status written via spec path bumps resourceVersion, re-triggering reconciliation.
