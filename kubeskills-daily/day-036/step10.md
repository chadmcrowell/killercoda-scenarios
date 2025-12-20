## Step 10: Test CronJob

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: test-cron
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: worker
            image: busybox
            command: ['sh', '-c', 'date; echo "Cron job run"']
          restartPolicy: Never
EOF
```{{exec}}

**Wait for execution:**
```bash
kubectl get cronjob test-cron -w
kubectl get jobs -l parent-cronjob=test-cron
```{{exec}}
