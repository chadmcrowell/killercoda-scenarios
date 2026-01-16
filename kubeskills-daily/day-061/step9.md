## Step 9: Test dependency issues

```bash
# Create chart with dependency
cat > broken-app/Chart.yaml << 'EOF'
apiVersion: v2
name: broken-app
version: 1.0.0
dependencies:
- name: postgresql
  version: "12.x.x"
  repository: https://charts.bitnami.com/bitnami
  condition: postgresql.enabled
EOF

# Try to install without updating dependencies
helm install dep-test broken-app 2>&1 || echo "Dependencies not found!"

# Update dependencies
helm dependency update broken-app

# Now install works
helm install dep-test broken-app --set postgresql.enabled=false
```{{exec}}

Dependencies must be downloaded before install.
