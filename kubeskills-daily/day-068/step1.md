## Step 1: Create successful Job

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: successful-job
spec:
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command: ['sh', '-c', 'echo Job complete!; sleep 5']
      restartPolicy: Never
EOF

# Watch job complete
kubectl get job successful-job -w
```{{exec}}

Watch a Job complete successfully.
