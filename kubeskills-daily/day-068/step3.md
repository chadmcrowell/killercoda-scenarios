## Step 3: Test Job with completions

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: multi-completion
spec:
  completions: 5  # Need 5 successful pods
  parallelism: 2  # Run 2 at a time
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command: ['sh', '-c', 'echo Processing...; sleep 5']
      restartPolicy: Never
EOF

# Watch pods created in batches
kubectl get pods -l job-name=multi-completion -w
```{{exec}}

See completions and parallelism in action.
