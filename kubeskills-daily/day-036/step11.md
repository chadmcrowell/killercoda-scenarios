## Step 11: Test CronJob with failedJobsHistoryLimit

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: failing-cron
spec:
  schedule: "*/1 * * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: fail
            image: busybox
            command: ['sh', '-c', 'exit 1']
          restartPolicy: Never
EOF
```{{exec}}

**Wait a few minutes:**
```bash
sleep 150
kubectl get jobs | grep failing-cron
```{{exec}}

Only one failed Job is retained while older failures are cleaned up.
