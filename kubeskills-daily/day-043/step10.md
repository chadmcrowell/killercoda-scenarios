## Step 10: Test baggage propagation

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: baggage-test
spec:
  containers:
  - name: test
    image: curlimages/curl:latest
    command: ['sh', '-c']
    args:
    - |
      curl -H "baggage: user-id=12345,session-id=abc" \
           -H "traceparent: 00-trace123-span123-01" \
           http://service-b:8080/
      sleep 3600
EOF
```{{exec}}

Baggage headers carry user context alongside trace context.
