## Step 5: Test activeDeadlineSeconds

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: timeout-job
spec:
  activeDeadlineSeconds: 30
  backoffLimit: 10
  template:
    spec:
      containers:
      - name: slow
        image: busybox
        command: ['sh', '-c', 'sleep 60']
      restartPolicy: Never
EOF
```{{exec}}

**Watch timeout:**
```bash
kubectl get job timeout-job -w
```{{exec}}

Job stops after 30 seconds regardless of backoffLimit.
