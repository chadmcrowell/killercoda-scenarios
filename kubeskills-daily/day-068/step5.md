## Step 5: Test Job with incorrect restartPolicy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: wrong-restart
spec:
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command: ['sh', '-c', 'echo Job running']
      restartPolicy: Always  # Wrong! Jobs require Never or OnFailure
EOF

# Job rejected
sleep 5
kubectl get job wrong-restart 2>&1 || echo "Job creation failed"
```{{exec}}

See validation fail for invalid restartPolicy.
