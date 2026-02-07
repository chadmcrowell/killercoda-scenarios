## Step 8: Test health check failures

```bash
# Deploy app that never becomes healthy
cat > /tmp/gitops-repo/unhealthy.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: unhealthy-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: unhealthy
  template:
    metadata:
      labels:
        app: unhealthy
    spec:
      containers:
      - name: app
        image: nginx
        readinessProbe:
          httpGet:
            path: /healthz  # Endpoint doesn't exist
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
EOF

kubectl apply -f /tmp/gitops-repo/unhealthy.yaml -n gitops-test

sleep 30

# Sync shows "Progressing" forever
kubectl get deployment unhealthy-app -n gitops-test
kubectl get pods -n gitops-test -l app=unhealthy
```{{exec}}

See how a failing readiness probe causes a deployment to stay in "Progressing" state indefinitely, blocking GitOps sync completion.
