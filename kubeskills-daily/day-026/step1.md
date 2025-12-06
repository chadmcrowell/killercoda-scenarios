## Step 1: Check node resource capacity

```bash
kubectl describe node | grep -A 10 "Allocatable:"
kubectl describe node | grep -A 10 "Allocated resources:"
```{{exec}}

Review allocatable vs allocated resources.
