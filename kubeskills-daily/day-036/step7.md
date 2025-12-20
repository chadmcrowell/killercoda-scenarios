## Step 7: Test parallelism

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: parallel-job
spec:
  completions: 10
  parallelism: 3
  template:
    spec:
      containers:
      - name: worker
        image: busybox
        command: ['sh', '-c', 'echo "Worker $HOSTNAME"; sleep 5']
      restartPolicy: Never
EOF
```{{exec}}

**Watch parallel execution:**
```bash
kubectl get pods -l job-name=parallel-job -w
```{{exec}}

Three pods run at once until all ten completions finish.
