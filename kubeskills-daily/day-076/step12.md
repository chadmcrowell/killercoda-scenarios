## Step 12: Test sync wave ordering

```bash
# Resources need specific order
cat > /tmp/gitops-repo/namespace.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: app-namespace
  annotations:
    argocd.argoproj.io/sync-wave: "0"  # Create first
EOF

cat > /tmp/gitops-repo/configmap-dep.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: app-namespace  # Depends on namespace
  annotations:
    argocd.argoproj.io/sync-wave: "1"  # Create second
data:
  key: value
EOF

cat > /tmp/gitops-repo/deployment-dep.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-config
  namespace: app-namespace
  annotations:
    argocd.argoproj.io/sync-wave: "2"  # Create last
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
      - name: app
        image: nginx
        envFrom:
        - configMapRef:
            name: app-config
EOF

echo "Without sync waves:"
echo "- Resources applied in random order"
echo "- Deployment fails (ConfigMap doesn't exist)"
echo "- Namespace doesn't exist yet"
```{{exec}}

Learn how sync waves control resource ordering to prevent failures from missing dependencies.
