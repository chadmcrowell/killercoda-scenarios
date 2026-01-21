## Step 11: Test Job with failing pod

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: retry-job
spec:
  backoffLimit: 5
  template:
    spec:
      containers:
      - name: job
        image: busybox
        command:
        - sh
        - -c
        - |
          ATTEMPT=$(cat /tmp/attempt 2>/dev/null || echo 0)
          ATTEMPT=$((ATTEMPT + 1))
          echo "Attempt $ATTEMPT"
          echo $ATTEMPT > /tmp/attempt
          if [ $ATTEMPT -lt 3 ]; then
            echo "Failing..."
            exit 1
          fi
          echo "Success on attempt $ATTEMPT!"
      restartPolicy: Never
EOF

# Watch retries
kubectl get pods -l job-name=retry-job -w
```{{exec}}

See retries succeed before backoffLimit.
