## Step 11: Time zone support (K8s 1.25+)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: timezone-job
spec:
  schedule: "0 9 * * *"  # 9 AM
  timeZone: "America/New_York"  # EST/EDT
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: app
            image: busybox
            command: ['sh', '-c', 'date; echo "Good morning!"']
          restartPolicy: Never
EOF
```{{exec}}

CronJobs can align to specific time zones when `timeZone` is set.
