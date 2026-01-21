<br>

### Job and CronJob lessons

**Key observations**

- Completions define how many pods must succeed.
- Parallelism controls how many pods run at once.
- backoffLimit limits retry attempts.
- activeDeadlineSeconds enforces timeouts.
- restartPolicy must be Never or OnFailure.
- CronJob concurrencyPolicy controls overlap.
- TTL cleans up completed jobs.

**Production patterns**

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processing
  namespace: production
spec:
  completions: 1
  backoffLimit: 3
  activeDeadlineSeconds: 3600  # 1 hour timeout
  ttlSecondsAfterFinished: 86400  # Cleanup after 24 hours
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: processor
        image: data-processor:v1.0
        env:
        - name: JOB_ID
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        resources:
          requests:
            cpu: "500m"
            memory: "1Gi"
          limits:
            cpu: "2000m"
            memory: "4Gi"
```

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: daily-backup
  namespace: production
spec:
  schedule: "0 2 * * *"  # 2 AM daily
  concurrencyPolicy: Forbid  # Don't overlap
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  startingDeadlineSeconds: 300  # Start within 5 minutes
  jobTemplate:
    spec:
      backoffLimit: 2
      activeDeadlineSeconds: 7200  # 2 hour max
      ttlSecondsAfterFinished: 259200  # 3 days
      template:
        spec:
          restartPolicy: OnFailure
          serviceAccountName: backup-sa
          containers:
          - name: backup
            image: backup-tool:v2.0
            env:
            - name: BACKUP_TARGET
              value: "s3://backups/daily"
            - name: TIMESTAMP
              value: "$(date +%Y%m%d)"
            resources:
              requests:
                cpu: "1000m"
                memory: "2Gi"
              limits:
                cpu: "2000m"
                memory: "4Gi"
          nodeSelector:
            workload-type: batch
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: parallel-processing
spec:
  completions: 100
  parallelism: 10
  completionMode: Indexed
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: worker
        image: worker:v1.0
        env:
        - name: WORKER_INDEX
          value: "$(JOB_COMPLETION_INDEX)"
        command:
        - sh
        - -c
        - |
          echo "Worker $JOB_COMPLETION_INDEX processing..."
          ./process-chunk.sh $JOB_COMPLETION_INDEX
```

```yaml
# Prometheus alerts
- alert: JobFailed
  expr: |
    kube_job_status_failed > 0
  for: 5m
  annotations:
    summary: "Job {{ $labels.namespace }}/{{ $labels.job_name }} failed"

- alert: JobTakingTooLong
  expr: |
    time() - kube_job_status_start_time > 3600
    and kube_job_status_active > 0
  annotations:
    summary: "Job {{ $labels.namespace }}/{{ $labels.job_name }} running > 1 hour"

- alert: CronJobMissedSchedule
  expr: |
    time() - kube_cronjob_status_last_schedule_time > 300
  for: 10m
  annotations:
    summary: "CronJob {{ $labels.namespace }}/{{ $labels.cronjob }} missed schedule"

- alert: TooManyFailedJobs
  expr: |
    count(kube_job_status_failed{job_name!=""}) by (namespace) > 10
  annotations:
    summary: "Namespace {{ $labels.namespace }} has > 10 failed jobs"
```

```bash
#!/bin/bash
# cleanup-old-jobs.sh

NAMESPACE=${1:-default}
DAYS_OLD=${2:-7}

echo "Cleaning up jobs older than $DAYS_OLD days in namespace $NAMESPACE..."

# Find old completed jobs
OLD_JOBS=$(kubectl get jobs -n $NAMESPACE -o json | \
  jq -r --arg days "$DAYS_OLD" '
    .items[] | 
    select(.status.completionTime != null) |
    select((now - (.status.completionTime | fromdateiso8601)) / 86400 > ($days | tonumber)) |
    .metadata.name
  ')

for job in $OLD_JOBS; do
  echo "Deleting job: $job"
  kubectl delete job -n $NAMESPACE $job
done

echo "Cleanup complete!"
```

**Cleanup**

```bash
kubectl delete job successful-job failing-job multi-completion timeout-job ttl-job retry-job indexed-job pod-failure-policy 2>/dev/null
kubectl delete cronjob every-minute long-running concurrent-allowed history-limit suspended-cron
rm -f /tmp/job-diagnosis.sh
```{{exec}}

---

🎉 **Week 10 Complete! Day 68 Achievement Unlocked!**
