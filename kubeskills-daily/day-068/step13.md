## Step 13: Test Job with indexed completions

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: indexed-job
spec:
  completions: 5
  parallelism: 2
  completionMode: Indexed  # Each pod gets unique index
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command:
        - sh
        - -c
        - |
          echo "Processing index: $JOB_COMPLETION_INDEX"
          sleep 5
      restartPolicy: Never
EOF

kubectl get pods -l job-name=indexed-job -w
```{{exec}}

Use indexed jobs for parallel processing.
