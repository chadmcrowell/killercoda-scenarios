## Step 6: Check eviction events

```bash
kubectl get events --sort-by='.lastTimestamp' | tail -20
```{{exec}}

Look for Evicted reasons like "The node was low on resource: memory".
