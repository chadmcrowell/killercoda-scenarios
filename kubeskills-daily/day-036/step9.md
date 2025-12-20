## Step 9: Test TTL after finished

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: ttl-job
spec:
  ttlSecondsAfterFinished: 30
  template:
    spec:
      containers:
      - name: quick
        image: busybox
        command: ['sh', '-c', 'echo "Done"; sleep 2']
      restartPolicy: Never
EOF
```{{exec}}

**Wait and check:**
```bash
sleep 35
kubectl get job ttl-job
```{{exec}}

The Job should be cleaned up automatically after 30 seconds.
