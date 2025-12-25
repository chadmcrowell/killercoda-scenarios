## Step 9: Test endpoint relabeling

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: relabel-monitor
  labels:
    team: frontend
spec:
  selector:
    matchLabels:
      app: metrics-app
  endpoints:
  - port: metrics
    interval: 30s
    relabelings:
    - sourceLabels: [__address__]
      targetLabel: instance
      replacement: 'my-custom-instance'
    - action: drop
      sourceLabels: [__meta_kubernetes_pod_name]
      regex: 'metrics-app-.*'
EOF
```{{exec}}

All targets are dropped by the final relabel rule.
