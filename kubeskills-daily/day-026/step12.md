## Step 12: Check eviction type and grace

```bash
kubectl get events --sort-by='.lastTimestamp' | grep -i evict
```{{exec}}

Events indicate soft vs hard evictions and which resources triggered them.
