## Step 7: Test missing instrumentation (gaps in trace)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-c-uninstrumented
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-c
  template:
    metadata:
      labels:
        app: service-c
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: service-c
spec:
  selector:
    app: service-c
  ports:
  - port: 80
EOF
```{{exec}}

Trace shows calls to service-c but no spans inside it due to missing instrumentation.
