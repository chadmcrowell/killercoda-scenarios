## Step 4: Deploy service B with propagation (fixed)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-b-fixed
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-b
      version: fixed
  template:
    metadata:
      labels:
        app: service-b
        version: fixed
    spec:
      containers:
      - name: app
        image: curlimages/curl:latest
        command: ['sh', '-c']
        args:
        - |
          while true; do
            nc -l -p 8080 -e sh -c '
              echo "HTTP/1.1 200 OK"
              echo "Content-Type: text/plain"
              echo ""
              echo "Service B - Propagated trace headers"
            '
          done
        ports:
        - containerPort: 8080
EOF
```{{exec}}

```bash
kubectl patch service service-b --type=merge -p '{"spec":{"selector":{"app":"service-b","version":"fixed"}}}'
```{{exec}}

Now Service B handles requests while keeping the trace context alive.
