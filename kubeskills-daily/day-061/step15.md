## Step 15: Test cleanup and orphaned resources

```bash
# Create resource not managed by Helm
cat > /tmp/orphan.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: orphaned-cm
  namespace: default
data:
  key: value
EOF

kubectl apply -f /tmp/orphan.yaml

# Uninstall release (orphaned resource remains)
helm uninstall test-release

# Check orphaned resource
kubectl get configmap orphaned-cm

# Cleanup
kubectl delete configmap orphaned-cm
kubectl delete deployment manual-deploy
```{{exec}}

Helm only cleans resources it created.
