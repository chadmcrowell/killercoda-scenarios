## Step 12: Test Job suspend

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: suspendable-job
spec:
  suspend: true
  parallelism: 5
  completions: 10
  template:
    spec:
      containers:
      - name: worker
        image: busybox
        command: ['sh', '-c', 'sleep 30']
      restartPolicy: Never
EOF
```{{exec}}

**Check pods:**
```bash
kubectl get pods -l job-name=suspendable-job
```{{exec}}

No pods appear because the Job is suspended.

**Resume:**
```bash
kubectl patch job suspendable-job -p '{"spec":{"suspend":false}}'
kubectl get pods -l job-name=suspendable-job -w
```{{exec}}

Pods start once the Job is resumed.
