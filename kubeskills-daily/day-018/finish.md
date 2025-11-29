<br>

### Jobs under control

**Key observations**

✅ `Allow` overlaps jobs; `Forbid` skips schedules; `Replace` cancels old runs.  
✅ History limits prune old Jobs to cap clutter.  
✅ `suspend: true` pauses scheduling without deleting the CronJob.  
✅ `startingDeadlineSeconds` flags missed schedules under load.  
✅ Backoff/retries still create pods—watch the count when failures loop.

**Production patterns**

Data backup CronJob:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: database-backup
spec:
  schedule: "0 2 * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 7
  failedJobsHistoryLimit: 3
  startingDeadlineSeconds: 900
  jobTemplate:
    spec:
      backoffLimit: 2
      template:
        spec:
          containers:
          - name: backup
            image: postgres:15
            command: ['pg_dump', '-h', 'db', '-U', 'user', 'mydb']
          restartPolicy: OnFailure
```

Metrics collection:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: metrics-collector
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Replace
  successfulJobsHistoryLimit: 1
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: collector
            image: metrics-collector:latest
          restartPolicy: Never
```

Cleanup job:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: cleanup-temp-files
spec:
  schedule: "0 3 * * 0"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cleanup
            image: busybox
            command:
            - sh
            - -c
            - find /data/temp -type f -mtime +7 -delete
```

**Cleanup**

```bash
kubectl delete cronjob slow-job-allow slow-job-forbid slow-job-replace fast-job deadline-job failing-job timezone-job business-hours-job 2>/dev/null
kubectl delete job --all
```{{exec}}

---

Next: Day 19 - ServiceAccount Token Mounting Issues
