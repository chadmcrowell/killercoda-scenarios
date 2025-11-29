## Step 12: Complex schedule expressions

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: business-hours-job
spec:
  schedule: "*/15 9-17 * * 1-5"  # Mon-Fri, 9AM-5PM, every 15 min
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: app
            image: busybox
            command: ['sh', '-c', 'echo "Business hours task"']
          restartPolicy: Never
EOF
```{{exec}}

Cron expressions support ranges, steps, and day-of-week windows for precise timing.
