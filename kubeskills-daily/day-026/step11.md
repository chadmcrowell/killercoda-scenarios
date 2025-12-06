## Step 11: Check node conditions

```bash
kubectl describe node | grep -A 10 "Conditions:"
```{{exec}}

Look for MemoryPressure, DiskPressure, and PIDPressure status.
