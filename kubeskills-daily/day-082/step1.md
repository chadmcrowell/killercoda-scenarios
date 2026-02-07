## Step 1: Deploy baseline configuration

```bash
# Deploy initial version
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    environment: production
    version: v1.0.0
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: nginx:1.21
        env:
        - name: ENVIRONMENT
          value: "production"
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: myapp-config
data:
  app.conf: |
    debug: false
    timeout: 30s
---
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  selector:
    app: myapp
  ports:
  - port: 80
EOF

kubectl wait --for=condition=Available deployment myapp --timeout=60s

# Save baseline state
kubectl get deployment myapp -o yaml > /tmp/baseline-deployment.yaml
kubectl get configmap myapp-config -o yaml > /tmp/baseline-configmap.yaml

echo "Baseline deployed and saved"
```{{exec}}

Deploy the initial baseline configuration and save snapshots to compare against future drift.
