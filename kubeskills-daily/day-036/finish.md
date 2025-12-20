<br>

### Job and CronJob backoff lessons

**Key observations**

- backoffLimit caps how many retries a Job gets before failing.
- Exponential backoff stretches timing: ~10s, 20s, 40s, 80s, 160s, 320s max.
- activeDeadlineSeconds sets a hard wall for total runtime.
- completions defines how many successes you need; parallelism controls concurrency.
- TTL after finished cleans up Jobs automatically.

**Production patterns**

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
spec:
  completions: 100
  parallelism: 10
  backoffLimit: 3
  activeDeadlineSeconds: 3600
  ttlSecondsAfterFinished: 86400
  template:
    spec:
      containers:
      - name: processor
        image: data-processor:v1
        resources:
          requests:
            cpu: "500m"
            memory: "1Gi"
          limits:
            cpu: "1"
            memory: "2Gi"
      restartPolicy: OnFailure
```

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
spec:
  schedule: "0 2 * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  startingDeadlineSeconds: 300
  jobTemplate:
    spec:
      backoffLimit: 2
      activeDeadlineSeconds: 1800
      template:
        spec:
          containers:
          - name: backup
            image: backup-tool:latest
          restartPolicy: OnFailure
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: distributed-task
spec:
  completions: 20
  parallelism: 5
  completionMode: Indexed
  template:
    spec:
      containers:
      - name: worker
        image: worker:latest
        env:
        - name: TASK_INDEX
          value: $(JOB_COMPLETION_INDEX)
      restartPolicy: Never
```

**Cleanup**

```bash
kubectl delete job failing-job no-retry-job timeout-job multi-completion parallel-job onfailure-job ttl-job suspendable-job indexed-job resource-starved 2>/dev/null
kubectl delete cronjob test-cron failing-cron 2>/dev/null
```{{exec}}

---

Next: Day 37 - TBD
