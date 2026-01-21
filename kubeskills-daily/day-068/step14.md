## Step 14: Test Job with pod failure policy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: pod-failure-policy
spec:
  backoffLimit: 3
  podFailurePolicy:
    rules:
    - action: FailJob  # Fail entire job
      onExitCodes:
        operator: In
        values: [42]
    - action: Ignore  # Don't count as failure
      onExitCodes:
        operator: In
        values: [1]
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command: ['sh', '-c', 'exit 42']  # Triggers FailJob
      restartPolicy: Never
EOF

sleep 10
kubectl describe job pod-failure-policy | grep -A 10 "Events:"
```{{exec}}

See how podFailurePolicy changes job behavior.
