## Step 4: Test Job timeout

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: timeout-job
spec:
  activeDeadlineSeconds: 10  # Must complete in 10 seconds
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command: ['sh', '-c', 'echo Starting...; sleep 30']
      restartPolicy: Never
EOF

# Job terminated after timeout
sleep 15
kubectl get job timeout-job
kubectl describe job timeout-job | grep -A 5 "Events:"
```{{exec}}

Trigger a timeout using activeDeadlineSeconds.
