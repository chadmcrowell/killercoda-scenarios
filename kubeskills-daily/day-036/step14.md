## Step 14: Test parallelism deadlock scenario

```bash
# Create Job that needs more resources than available
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: resource-starved
spec:
  completions: 10
  parallelism: 10
  template:
    spec:
      containers:
      - name: hungry
        image: busybox
        command: ['sleep', '30']
        resources:
          requests:
            memory: "2Gi"
            cpu: "1"
      restartPolicy: Never
EOF
```{{exec}}

**Check pods:**
```bash
kubectl get pods -l job-name=resource-starved
```{{exec}}

Some pods stay Pending because the cluster cannot schedule all ten at once.
