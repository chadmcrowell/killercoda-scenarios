## Step 2: Test manifest validation failure

```bash
# Create invalid manifest in Git
cat > /tmp/gitops-repo/base/invalid.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken
spec:
  replicas: 2
  # Missing required selector!
  template:
    metadata:
      labels:
        app: broken
    spec:
      containers:
      - name: app
        image: nginx
EOF

# Update kustomization
cat >> /tmp/gitops-repo/base/kustomization.yaml << 'EOF'
- invalid.yaml
EOF

# Try to apply
kubectl apply -k /tmp/gitops-repo/base 2>&1 || echo "Sync would fail - invalid manifest!"
```{{exec}}

Observe how an invalid manifest (missing required selector field) causes the entire sync to fail.
