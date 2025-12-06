## Step 13: Check PSA violations in events

```bash
kubectl get events -n psa-restricted --sort-by='.lastTimestamp' | grep -i violat
```{{exec}}

Events show PSA deny/warn messages.
