## Step 6: Test completions (multiple successful runs)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: multi-completion
spec:
  completions: 5
  parallelism: 1
  template:
    spec:
      containers:
      - name: worker
        image: busybox
        command: ['sh', '-c', 'echo "Processing..."; sleep 3; echo "Done"']
      restartPolicy: Never
EOF
```{{exec}}

**Watch sequential execution:**
```bash
kubectl get pods -l job-name=multi-completion -w
```{{exec}}

Five pods run one after another because parallelism is 1.
