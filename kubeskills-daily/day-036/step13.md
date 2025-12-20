## Step 13: Test Job with indexed completion mode

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: indexed-job
spec:
  completions: 5
  parallelism: 2
  completionMode: Indexed
  template:
    spec:
      containers:
      - name: worker
        image: busybox
        command: ['sh', '-c']
        args:
        - |
          echo "Processing index: $JOB_COMPLETION_INDEX"
          sleep 5
      restartPolicy: Never
EOF
```{{exec}}

**Check environment variable:**
```bash
kubectl logs -l job-name=indexed-job --tail=5 | grep "Processing index"
```{{exec}}

Each pod prints its assigned index via JOB_COMPLETION_INDEX.
