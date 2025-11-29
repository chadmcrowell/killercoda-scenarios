## Step 7: Suspend a CronJob

```bash
kubectl patch cronjob slow-job-allow -p '{"spec":{"suspend":true}}'
```{{exec}}

```bash
kubectl get cronjob slow-job-allow
```{{exec}}

SUSPEND shows True. Resume when ready:

```bash
kubectl patch cronjob slow-job-allow -p '{"spec":{"suspend":false}}'
```{{exec}}
