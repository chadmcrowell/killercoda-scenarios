## Step 3: Try to exceed pod quota

```bash
# Try to scale beyond pod limit
kubectl scale deployment within-quota -n quota-test --replicas=6

sleep 10

# Check actual replicas
kubectl get deployment within-quota -n quota-test

# Check events
kubectl get events -n quota-test --sort-by='.lastTimestamp' | grep -i quota | tail -5
```{{exec}}

Observe quota enforcement when scaling beyond pod limits.
