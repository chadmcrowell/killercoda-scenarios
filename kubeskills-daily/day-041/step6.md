## Step 6: Fix ServiceMonitor label

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: correct-label-monitor
  namespace: default
  labels:
    team: frontend
spec:
  selector:
    matchLabels:
      app: metrics-app
  endpoints:
  - port: metrics
    interval: 30s
EOF
```{{exec}}

Prometheus now discovers targets (though metrics endpoint still dummy nginx).
