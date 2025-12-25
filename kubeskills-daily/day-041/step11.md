## Step 11: Test namespace selector

```bash
kubectl create namespace production

cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prod-app
  namespace: production
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prod-app
  template:
    metadata:
      labels:
        app: prod-app
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - name: metrics
          containerPort: 9113
---
apiVersion: v1
kind: Service
metadata:
  name: prod-app-svc
  namespace: production
  labels:
    app: prod-app
spec:
  selector:
    app: prod-app
  ports:
  - name: metrics
    port: 9113
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: prod-monitor
  namespace: production
  labels:
    team: frontend
spec:
  selector:
    matchLabels:
      app: prod-app
  endpoints:
  - port: metrics
EOF
```{{exec}}

Prometheus misses this monitor by default (different namespace).

```bash
kubectl patch prometheus prometheus -n monitoring --type=merge -p '{"spec":{"serviceMonitorNamespaceSelector":{}}}'
```{{exec}}

Patching Prometheus to watch all namespaces discovers the production monitor.
