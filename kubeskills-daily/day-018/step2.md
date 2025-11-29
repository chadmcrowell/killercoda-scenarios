## Step 2: Watch jobs pile up

```bash
kubectl get cronjobs,jobs,pods -w
```{{exec}}

After ~5 minutes you should see several concurrent jobs from the Allow policy.

```bash
kubectl get jobs -l job-name
kubectl describe cronjob slow-job-allow
```{{exec}}

Check how many jobs remain active and the configured history limits.
