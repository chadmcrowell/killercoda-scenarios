## Step 6: Create CronJob

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: every-minute
spec:
  schedule: "*/1 * * * *"  # Every minute
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: job
            image: busybox
            command: ['sh', '-c', 'date; echo CronJob executed']
          restartPolicy: Never
EOF

# Wait for job to run
sleep 70

# Check jobs created
kubectl get jobs -l batch.kubernetes.io/controller-uid=$(kubectl get cronjob every-minute -o jsonpath='{.metadata.uid}')
```{{exec}}

Create a CronJob and verify jobs are created.
