## Step 7: Simulate node memory pressure

```bash
kubectl describe node | grep -A 5 "Allocated resources"
```{{exec}}

When memory is tight, eviction order is: BestEffort → Burstable (exceeding requests) → Guaranteed (last resort).
