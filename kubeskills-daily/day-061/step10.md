## Step 10: Test conflicting resources

```bash
# Create resource manually
kubectl create deployment manual-deploy --image=nginx

# Create chart that tries to create same resource
cat > broken-app/templates/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: manual-deploy  # Same name!
spec:
  replicas: 1
  selector:
    matchLabels:
      app: manual
  template:
    metadata:
      labels:
        app: manual
    spec:
      containers:
      - name: nginx
        image: nginx
EOF

# Try to install
helm install conflict-test broken-app 2>&1 || echo "Resource already exists!"

# Check existing resource
kubectl get deployment manual-deploy -o yaml | grep -A 5 "metadata:"
```{{exec}}

Helm cannot adopt resources it does not own.
