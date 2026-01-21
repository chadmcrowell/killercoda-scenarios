## Step 8: Test CronJob concurrency policies

```bash
# Allow concurrent runs
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: concurrent-allowed
spec:
  schedule: "*/1 * * * *"
  concurrencyPolicy: Allow  # Allow overlapping runs
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: job
            image: busybox
            command: ['sh', '-c', 'echo Starting; sleep 90']
          restartPolicy: Never
EOF

sleep 130

# Multiple jobs running simultaneously
kubectl get jobs -l batch.kubernetes.io/controller-uid=$(kubectl get cronjob concurrent-allowed -o jsonpath='{.metadata.uid}')
```{{exec}}

Allow overlapping CronJob runs.
