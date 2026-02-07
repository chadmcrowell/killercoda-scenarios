## Step 11: Test webhook authentication failure

```bash
# Simulate webhook configuration
cat > /tmp/webhook-config.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: webhook-config
data:
  webhook-url: https://gitops.example.com/webhook
  secret: wrong-secret  # Authentication fails!
EOF

echo "Webhook failures cause:"
echo "- Git push doesn't trigger sync"
echo "- Deployments delayed"
echo "- No automatic reconciliation"
echo "- Manual sync required"
```{{exec}}

Understand how webhook authentication failures silently break the automatic sync trigger from Git pushes.
