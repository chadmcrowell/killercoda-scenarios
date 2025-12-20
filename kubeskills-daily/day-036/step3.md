## Step 3: Check Job status

```bash
kubectl get job failing-job
kubectl describe job failing-job | grep -A 10 "Pods Statuses:"
```{{exec}}

Expect 0 Succeeded and 5 Failed attempts.
