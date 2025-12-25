## Step 10: Test multiple endpoints

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: multi-endpoint-monitor
  labels:
    team: frontend
spec:
  selector:
    matchLabels:
      app: metrics-app
  endpoints:
  - port: metrics
    interval: 30s
    path: /metrics
  - port: web
    interval: 30s
    path: /nginx-metrics
EOF
```{{exec}}

Prometheus creates two scrape configs for the service (metrics and web paths).
