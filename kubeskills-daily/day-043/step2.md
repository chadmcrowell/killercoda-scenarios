## Step 2: Deploy service A (with tracing headers)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-a
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-a
  template:
    metadata:
      labels:
        app: service-a
    spec:
      containers:
      - name: app
        image: curlimages/curl:latest
        command: ['sh', '-c']
        args:
        - |
          while true; do
            TRACE_ID=$(cat /proc/sys/kernel/random/uuid | cut -d- -f1)
            SPAN_ID=$(cat /proc/sys/kernel/random/uuid | cut -d- -f1 | cut -c1-16)
            echo "Starting trace: $TRACE_ID"
            curl -H "traceparent: 00-$TRACE_ID-$SPAN_ID-01" \
                 http://service-b:8080/ 2>/dev/null || echo "Service B unreachable"
            sleep 10
          done
---
apiVersion: v1
kind: Service
metadata:
  name: service-a
spec:
  selector:
    app: service-a
  ports:
  - port: 8080
EOF
```{{exec}}

Service A sends traceparent headers to Service B.
