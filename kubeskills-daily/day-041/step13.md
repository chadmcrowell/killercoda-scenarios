## Step 13: Test PodMonitor (scrape pods directly)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: pod-monitor
  labels:
    team: frontend
spec:
  selector:
    matchLabels:
      app: metrics-app
  podMetricsEndpoints:
  - port: metrics
    interval: 30s
EOF
```{{exec}}

PodMonitor scrapes pods without needing a Service.
