## Step 5: Test sync with wrong namespace

```bash
# Manifest specifies namespace
cat > /tmp/gitops-repo/wrong-namespace.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: config
  namespace: production  # Wrong namespace!
data:
  key: value
EOF

# Try to apply to different namespace
kubectl apply -f /tmp/gitops-repo/wrong-namespace.yaml -n gitops-test 2>&1 || echo "Namespace mismatch!"
```{{exec}}

See what happens when a manifest hardcodes a namespace that conflicts with the target namespace.
