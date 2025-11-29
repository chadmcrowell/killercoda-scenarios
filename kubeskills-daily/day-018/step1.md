## Step 1: Create CronJob with Allow policy (default)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: slow-job-allow
spec:
  schedule: "*/1 * * * *"  # Every minute
  concurrencyPolicy: Allow
  successfulJobsHistoryLimit: 5
  failedJobsHistoryLimit: 3
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: sleeper
            image: busybox
            command:
            - /bin/sh
            - -c
            - echo "Job started at $(date)"; sleep 300; echo "Job finished at $(date)"
          restartPolicy: Never
EOF
```{{exec}}

Allow lets each schedule start a new Job even if previous runs are still active.
