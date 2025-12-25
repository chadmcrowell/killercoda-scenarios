## Step 5: Create ServiceMonitor with wrong label (fails!)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: wrong-label-monitor
  namespace: default
  labels:
    team: backend
spec:
  selector:
    matchLabels:
      app: metrics-app
  endpoints:
  - port: metrics
    interval: 30s
EOF
```{{exec}}

Prometheus ignores this monitor because label `team: backend` does not match `team: frontend` selector.
