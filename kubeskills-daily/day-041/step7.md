## Step 7: Test missing port name

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: no-port-name-svc
  labels:
    app: no-port-name
spec:
  selector:
    app: metrics-app
  ports:
  - port: 9113
    targetPort: 9113
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: no-port-monitor
  labels:
    team: frontend
spec:
  selector:
    matchLabels:
      app: no-port-name
  endpoints:
  - port: metrics
    interval: 30s
EOF
```{{exec}}

```bash
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus --tail=50 | grep -i "no-port-name" || true
```{{exec}}

Prometheus errors: port "metrics" not found because the service port lacks a name.
