## Step 10: Test Job TTL cleanup

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: ttl-job
spec:
  ttlSecondsAfterFinished: 30  # Delete 30s after completion
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command: ['sh', '-c', 'echo Done']
      restartPolicy: Never
EOF

# Job auto-deleted after 30s
kubectl get job ttl-job

sleep 35

kubectl get job ttl-job 2>&1 || echo "Job cleaned up by TTL"
```{{exec}}

Watch TTL controller clean up completed Jobs.
