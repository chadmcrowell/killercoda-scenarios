## Step 8: Test startingDeadlineSeconds

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: deadline-job
spec:
  schedule: "*/1 * * * *"
  startingDeadlineSeconds: 30  # Must start within 30s of schedule
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: app
            image: busybox
            command: ['sh', '-c', 'echo "Running"; sleep 10']
          restartPolicy: Never
EOF
```{{exec}}

```bash
kubectl describe cronjob deadline-job | grep -A 5 "Last Schedule Time"
```{{exec}}

Missed schedules appear if jobs cannot start within the deadline.
