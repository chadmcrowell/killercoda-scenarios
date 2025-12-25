## Step 8: Test collector back-pressure

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: span-flood
spec:
  containers:
  - name: flood
    image: curlimages/curl:latest
    command: ['sh', '-c']
    args:
    - |
      while true; do
        for i in $(seq 1 100); do
          TRACE_ID=$(cat /proc/sys/kernel/random/uuid | cut -d- -f1)
          curl -X POST http://otel-collector.tracing.svc:4317/v1/traces \
            -H "Content-Type: application/json" \
            -d "{\"traceId\":\"$TRACE_ID\"}" 2>/dev/null &
        done
        sleep 0.1
      done
EOF
```{{exec}}

```bash
kubectl logs -n tracing -l app=otel-collector --tail=50 | grep -i "buffer\|drop\|backpressure"
```{{exec}}

Heavy span volume can trigger collector back-pressure warnings.
