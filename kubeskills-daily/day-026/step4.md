## Step 4: Check current node memory usage

```bash
kubectl top node
kubectl describe node | grep -A 5 "Allocated resources:"
```{{exec}}

Snapshot current usage before inducing pressure.
