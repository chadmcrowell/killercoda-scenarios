## Step 12: Check pod deletion timestamp

```bash
kubectl get pods -o json | jq -r '.items[] | select(.metadata.deletionTimestamp != null) | {name: .metadata.name, deletionTimestamp: .metadata.deletionTimestamp, deletionGracePeriodSeconds: .metadata.deletionGracePeriodSeconds}'
```{{exec}}

Shows pods stuck Terminating with deletionTimestamp and grace period.
