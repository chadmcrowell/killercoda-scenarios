## Step 10: Check event storm

```bash
kubectl get events --sort-by='.lastTimestamp' | grep test-app | tail -20
```{{exec}}

Review noisy events produced by rapid reconciliations.
