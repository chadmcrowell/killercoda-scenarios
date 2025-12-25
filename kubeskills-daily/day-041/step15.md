## Step 15: Test PrometheusRule (alerting)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: example-rules
  namespace: monitoring
  labels:
    prometheus: prometheus
spec:
  groups:
  - name: example
    interval: 30s
    rules:
    - alert: HighErrorRate
      expr: rate(http_requests_total{status="500"}[5m]) > 0.05
      for: 10m
      labels:
        severity: critical
      annotations:
        summary: "High error rate detected"
EOF
```{{exec}}

Check the rule in Prometheus UI at `/rules` via the port-forward.
