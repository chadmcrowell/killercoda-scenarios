## Step 9: Job failure handling

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: failing-job
spec:
  schedule: "*/2 * * * *"
  jobTemplate:
    spec:
      backoffLimit: 3  # Retry 3 times
      template:
        spec:
          containers:
          - name: failer
            image: busybox
            command: ['sh', '-c', 'echo "Attempt failed"; exit 1']
          restartPolicy: Never
EOF
```{{exec}}

```bash
kubectl get jobs,pods -l 'job-name' -w
```{{exec}}

Expect one initial pod plus three retries, then the Job is marked Failed.
