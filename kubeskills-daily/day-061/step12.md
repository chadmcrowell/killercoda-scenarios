## Step 12: Test values override

```bash
# Create override values file
cat > /tmp/override-values.yaml << 'EOF'
replicaCount: 5
image:
  repository: nginx
  tag: "1.25"
service:
  port: 8080
EOF

# Install with overrides
helm upgrade test-release broken-app \
  --values /tmp/override-values.yaml \
  --set replicaCount=3  # --set takes precedence over -f

# Check final values
helm get values test-release
```{{exec}}

Overrides stack in order; --set wins over files.
