## Step 4: Check skipped runs

```bash
kubectl describe cronjob slow-job-forbid | grep -A 10 Events
```{{exec}}

Look for events like `skipping schedule` while a previous job is still running.
