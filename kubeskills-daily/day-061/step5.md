## Step 5: Test with valid values

```bash
# Add replicaCount back
cat > broken-app/values.yaml << 'EOF'
replicaCount: 2

image:
  repository: nginx
  tag: latest

service:
  port: 80
EOF

# Install successfully
helm install test-release broken-app

# Check status
helm status test-release
kubectl get all -l app=test-release
```{{exec}}

A correct values file allows the chart to install.
