## Step 7: Check node conditions

```bash
kubectl describe node | grep -A 5 "Conditions:"
```{{exec}}

Look for MemoryPressure=True when the node is stressed.
