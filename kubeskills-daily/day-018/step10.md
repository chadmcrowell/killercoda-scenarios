## Step 10: Manual job trigger

```bash
kubectl create job manual-run --from=cronjob/fast-job
```{{exec}}

```bash
kubectl get job manual-run
kubectl logs job/manual-run
```{{exec}}

Manually creating a Job from a CronJob template lets you test on demand.
