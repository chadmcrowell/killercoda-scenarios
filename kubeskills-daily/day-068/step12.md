## Step 12: Test suspended CronJob

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: suspended-cron
spec:
  schedule: "*/1 * * * *"
  suspend: true  # Don't run
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: job
            image: busybox
            command: ['sh', '-c', 'echo Should not run']
          restartPolicy: Never
EOF

# Wait - no jobs created
sleep 70
kubectl get jobs -l batch.kubernetes.io/controller-uid=$(kubectl get cronjob suspended-cron -o jsonpath='{.metadata.uid}') || echo "No jobs created (suspended)"
```{{exec}}

Confirm that suspended CronJobs do not run.
