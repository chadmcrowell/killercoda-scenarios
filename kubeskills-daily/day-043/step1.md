## Step 1: Install Jaeger (all-in-one)

```bash
kubectl create namespace tracing

cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jaeger
  namespace: tracing
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jaeger
  template:
    metadata:
      labels:
        app: jaeger
    spec:
      containers:
      - name: jaeger
        image: jaegertracing/all-in-one:1.50
        env:
        - name: COLLECTOR_OTLP_ENABLED
          value: "true"
        ports:
        - containerPort: 16686
        - containerPort: 4317
        - containerPort: 4318
        - containerPort: 14268
---
apiVersion: v1
kind: Service
metadata:
  name: jaeger
  namespace: tracing
spec:
  selector:
    app: jaeger
  ports:
  - name: ui
    port: 16686
    targetPort: 16686
  - name: otlp-grpc
    port: 4317
    targetPort: 4317
  - name: otlp-http
    port: 4318
    targetPort: 4318
  - name: jaeger-http
    port: 14268
    targetPort: 14268
EOF
```{{exec}}

```bash
kubectl port-forward -n tracing svc/jaeger 16686:16686 > /dev/null 2>&1 &
```{{exec}}

Port-forward the Jaeger UI at http://localhost:16686.
