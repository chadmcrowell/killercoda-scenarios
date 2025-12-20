## Step 15: Check kubelet eviction thresholds

```bash
# View kubelet config flags (if available)
# kubelet --help | grep -A 10 eviction

kubectl get node -o json | jq '.items[0].status | {capacity, allocatable}'
```{{exec}}

Review allocatable vs capacity to understand eviction margins.
