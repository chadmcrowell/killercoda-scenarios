## Step 9: Test CronJob history limits

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: history-limit
spec:
  schedule: "*/1 * * * *"
  successfulJobsHistoryLimit: 2  # Keep only 2 successful
  failedJobsHistoryLimit: 1       # Keep only 1 failed
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: job
            image: busybox
            command: ['sh', '-c', 'date']
          restartPolicy: Never
EOF

# Wait for several runs
sleep 250

# Check job count (should be limited)
kubectl get jobs -l batch.kubernetes.io/controller-uid=$(kubectl get cronjob history-limit -o jsonpath='{.metadata.uid}')
```{{exec}}

Verify job history cleanup limits.
