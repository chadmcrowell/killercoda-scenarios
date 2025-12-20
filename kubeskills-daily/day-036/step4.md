## Step 4: Test with backoffLimit=0 (no retries)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: no-retry-job
spec:
  backoffLimit: 0
  template:
    spec:
      containers:
      - name: fail
        image: busybox
        command: ['sh', '-c', 'exit 1']
      restartPolicy: Never
EOF
```{{exec}}

**Check pods:**
```bash
kubectl get pods -l job-name=no-retry-job
```{{exec}}

Only 1 pod is created; no retries happen.
