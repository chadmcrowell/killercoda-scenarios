## Step 10: Test auto-sync with bad manifest

```bash
# Simulate auto-sync pushing broken manifest
cat > /tmp/gitops-repo/auto-sync-bad.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auto-sync-test
spec:
  replicas: 100  # Way too many!
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
        resources:
          requests:
            cpu: "10"  # Unrealistic
            memory: "50Gi"
EOF

echo "With auto-sync enabled:"
echo "- Bad manifest automatically applied"
echo "- Cluster tries to schedule 100 pods"
echo "- Resource exhaustion"
echo "- No manual approval gate"

# Don't actually apply this
```{{exec}}

See the risks of auto-sync without guardrails: a bad manifest can exhaust cluster resources automatically.
