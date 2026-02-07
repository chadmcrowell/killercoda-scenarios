## Step 1: Simulate GitOps repository structure

```bash
# Create local "Git repo" structure
mkdir -p /tmp/gitops-repo/{base,overlays/dev,overlays/prod}

# Base manifests
cat > /tmp/gitops-repo/base/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 2
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
        ports:
        - containerPort: 80
EOF

cat > /tmp/gitops-repo/base/service.yaml << 'EOF'
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

# Kustomization
cat > /tmp/gitops-repo/base/kustomization.yaml << 'EOF'
resources:
- deployment.yaml
- service.yaml
EOF

echo "GitOps repo structure created"
tree /tmp/gitops-repo 2>/dev/null || find /tmp/gitops-repo
```{{exec}}

Set up a local directory structure simulating a GitOps repository with base manifests and overlays.
