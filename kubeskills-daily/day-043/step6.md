## Step 6: Deploy instrumented app with OpenTelemetry

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-config
  namespace: tracing
data:
  otel-config.yaml: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
    processors:
      batch:
        timeout: 1s
        send_batch_size: 1024
    exporters:
      otlp:
        endpoint: jaeger.tracing.svc:4317
        tls:
          insecure: true
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [otlp]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: otel-collector
  namespace: tracing
spec:
  replicas: 1
  selector:
    matchLabels:
      app: otel-collector
  template:
    metadata:
      labels:
        app: otel-collector
    spec:
      containers:
      - name: collector
        image: otel/opentelemetry-collector:0.88.0
        args: ["--config=/etc/otel/config.yaml"]
        ports:
        - containerPort: 4317
        volumeMounts:
        - name: config
          mountPath: /etc/otel
      volumes:
      - name: config
        configMap:
          name: otel-config
---
apiVersion: v1
kind: Service
metadata:
  name: otel-collector
  namespace: tracing
spec:
  selector:
    app: otel-collector
  ports:
  - port: 4317
    targetPort: 4317
EOF
```{{exec}}

Collector receives OTLP and forwards to Jaeger.
