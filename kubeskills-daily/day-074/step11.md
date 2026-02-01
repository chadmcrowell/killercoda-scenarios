## Step 11: Test backup scheduling failure

```bash
# Create CronJob for backups
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
  namespace: backup-test
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: bitnami/kubectl
            command:
            - sh
            - -c
            - |
              echo "Running backup..."
              kubectl get all -n backup-test -o yaml > /backup/backup.yaml
              echo "Backup complete"
          restartPolicy: OnFailure
EOF

# Check if CronJob runs
kubectl get cronjob -n backup-test

# Simulate missed schedule
echo "If previous run still active, next schedule missed!"
```{{exec}}

CronJob schedules can miss if previous job is still running.
