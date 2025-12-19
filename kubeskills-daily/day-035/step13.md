## Step 13: Test Job with init container

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: job-with-init
spec:
  template:
    spec:
      initContainers:
      - name: setup
        image: busybox
        command: ['sh', '-c', 'echo "Setting up..."; sleep 3']
      containers:
      - name: worker
        image: busybox
        command: ['sh', '-c', 'echo "Job running"; sleep 5; echo "Job done"']
      restartPolicy: Never
EOF
```{{exec}}

```bash
kubectl get job job-with-init -w
kubectl logs job/job-with-init -c setup
kubectl logs job/job-with-init -c worker
```{{exec}}

The Job runs its init first, then the worker, and completes successfully.
