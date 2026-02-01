## Step 9: Test quota bypass via node resources

```bash
# Even with quota, can exhaust node resources
echo "ResourceQuota limits namespace resources"
echo "But pods share node CPU/memory/disk"
echo "One tenant can starve others on same node"

# Check pod distribution
kubectl get pods -A -o wide | grep -E "team-a|team-b" | awk '{print $8}' | sort | uniq -c
```{{exec}}

ResourceQuotas are namespace-scoped, but nodes are shared.
