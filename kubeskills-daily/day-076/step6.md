## Step 6: Test circular dependency

```bash
# Create resources with circular dependency
cat > /tmp/gitops-repo/circular-a.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-a
data:
  ref: config-b
EOF

cat > /tmp/gitops-repo/circular-b.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-b
  annotations:
    depends-on: config-a  # Circular!
data:
  ref: config-a
EOF

echo "Circular dependencies cause:"
echo "- Sync loops"
echo "- Health check failures"
echo "- Resources stuck progressing"
```{{exec}}

Explore how circular dependencies between resources can cause infinite sync loops and stuck deployments.
