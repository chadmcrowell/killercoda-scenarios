## Step 2: Test failing Job

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: failing-job
spec:
  backoffLimit: 3  # Retry 3 times
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command: ['sh', '-c', 'echo Failing...; exit 1']
      restartPolicy: Never
EOF

# Watch retries
kubectl get job failing-job -w
```{{exec}}

Observe retries and backoff behavior.
