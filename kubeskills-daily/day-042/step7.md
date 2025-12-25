## Step 7: Test buffer overflow

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: log-flood
spec:
  containers:
  - name: flood
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      while true; do
        for i in $(seq 1 1000); do
          echo "Log flood message $i at $(date)"
        done
        sleep 0.1
      done
EOF
```{{exec}}

```bash
kubectl top pod -n logging || true
kubectl logs -n logging -l app=fluent-bit --tail=100 | grep -i "buffer\|overflow\|backpressure"
```{{exec}}

High-volume logs can trigger buffer or backpressure messages.
