## Step 8: Test Job with OnFailure restart policy

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: onfailure-job
spec:
  backoffLimit: 3
  template:
    spec:
      containers:
      - name: retry
        image: busybox
        command: ['sh', '-c']
        args:
        - |
          if [ ! -f /tmp/attempted ]; then
            touch /tmp/attempted
            echo "First attempt, failing"
            exit 1
          else
            echo "Retry succeeded"
            exit 0
          fi
      restartPolicy: OnFailure
EOF
```{{exec}}

**Check behavior:**
```bash
kubectl get pods -l job-name=onfailure-job -w
```{{exec}}

The same pod restarts on failure instead of spawning new pods.
