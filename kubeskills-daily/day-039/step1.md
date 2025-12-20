## Step 1: Check node resources

```bash
kubectl describe node | grep -A 10 "Allocatable:"
kubectl describe node | grep -A 10 "Allocated resources:"
```{{exec}}

Note allocatable vs already allocated resources before stressing the node.
