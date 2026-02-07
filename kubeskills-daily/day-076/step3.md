## Step 3: Test Kustomize rendering failure

```bash
# Create overlay with wrong base path
mkdir -p /tmp/gitops-repo/overlays/staging

cat > /tmp/gitops-repo/overlays/staging/kustomization.yaml << 'EOF'
bases:
- ../../wrong-path  # Path doesn't exist!

patchesStrategicMerge:
- replica-patch.yaml
EOF

# Try to build
kubectl kustomize /tmp/gitops-repo/overlays/staging 2>&1 || echo "Kustomize build failed!"
```{{exec}}

See how a misconfigured Kustomize overlay with a wrong base path prevents rendering entirely.
