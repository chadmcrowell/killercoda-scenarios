## Step 4: Check that nodes remain Ready

```bash
kubectl get nodes
kubectl get pods -o wide
```{{exec}}

Nodes/pods look healthy even during a partition.
