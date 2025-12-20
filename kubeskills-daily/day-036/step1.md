## Step 1: Create basic failing Job

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: failing-job
spec:
  backoffLimit: 4
  template:
    spec:
      containers:
      - name: fail
        image: busybox
        command: ['sh', '-c', 'echo "Attempt failed"; exit 1']
      restartPolicy: Never
EOF
```{{exec}}

**Watch backoff progression:**
```bash
kubectl get pods -l job-name=failing-job -w
```{{exec}}

Creates 5 pods total (initial + 4 retries).
