## Step 3: Create CronJob with Forbid policy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: slow-job-forbid
spec:
  schedule: "*/1 * * * *"
  concurrencyPolicy: Forbid
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
            - echo "Forbid job started at $(date)"; sleep 300; echo "Forbid job finished"
          restartPolicy: Never
EOF
```{{exec}}

```bash
kubectl get cronjobs slow-job-forbid -w
```{{exec}}

Forbid skips starting a new Job if the prior run is still active.
