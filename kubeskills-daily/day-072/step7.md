## Step 7: Test CronJob API version change

```bash
# CronJob moved from batch/v1beta1 to batch/v1 in 1.21
# Old API
cat <<EOF > /tmp/old-cronjob.yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: old-cronjob
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: job
            image: busybox
            command: ['echo', 'hello']
          restartPolicy: Never
EOF

kubectl apply -f /tmp/old-cronjob.yaml 2>&1 || echo "Old CronJob API may not be supported"

# New API
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: new-cronjob
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: job
            image: busybox
            command: ['echo', 'hello']
          restartPolicy: Never
EOF
```{{exec}}

CronJob API moved to batch/v1 in 1.21, v1beta1 deprecated.
