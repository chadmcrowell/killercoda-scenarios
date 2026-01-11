## Step 1: Check cluster capacity

```bash
# Get node allocatable resources
kubectl describe nodes | grep -A 5 "Allocatable:"

# Get current allocation
kubectl describe nodes | grep -A 10 "Allocated resources:"

# Summary view
kubectl top nodes
```{{exec}}

Review allocatable vs allocated resources to see headroom.
