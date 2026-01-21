## Step 7: Test CronJob schedule miss

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: long-running
spec:
  schedule: "*/1 * * * *"
  concurrencyPolicy: Forbid  # Don't start if previous still running
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: job
            image: busybox
            command: ['sh', '-c', 'echo Starting...; sleep 90']  # Takes 90s
          restartPolicy: Never
EOF

# Wait for schedule conflict
sleep 130

# Check jobs
kubectl get jobs -l batch.kubernetes.io/controller-uid=$(kubectl get cronjob long-running -o jsonpath='{.metadata.uid}')
kubectl get events --sort-by='.lastTimestamp' | grep long-running | tail -5
```{{exec}}

Observe missed schedules with Forbid policy.
