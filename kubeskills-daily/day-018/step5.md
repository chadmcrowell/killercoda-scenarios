## Step 5: Create CronJob with Replace policy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: slow-job-replace
spec:
  schedule: "*/1 * * * *"
  concurrencyPolicy: Replace
  successfulJobsHistoryLimit: 5
  failedJobsHistoryLimit: 3
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: sleeper
            image: busybox
            command:
            - /bin/sh
            - -c
            - echo "Replace job started at $(date) with ID=$HOSTNAME"; sleep 300; echo "Finished"
          restartPolicy: Never
EOF
```{{exec}}

```bash
kubectl get jobs,pods -l 'job-name' -w
```{{exec}}

Replace kills the previous job when a new schedule fires, avoiding overlap.
