## Step 2: Check node status

```bash
kubectl get nodes
kubectl describe nodes | grep -A 5 "Conditions:"
```{{exec}}

Inspect node readiness/conditions.
