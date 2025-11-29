## Step 6: Test job completion and history

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: fast-job
spec:
  schedule: "*/1 * * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: quick
            image: busybox
            command: ['sh', '-c', 'echo "Quick job"; sleep 5']
          restartPolicy: Never
EOF
```{{exec}}

```bash
kubectl get jobs -l 'job-name'
```{{exec}}

After several runs, only the last three successful jobs are retained.
