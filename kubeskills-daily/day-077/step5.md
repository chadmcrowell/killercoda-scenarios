## Step 5: Secret in Git repository

```bash
# BAD: Secret checked into Git
mkdir -p /tmp/git-leak
cat > /tmp/git-leak/secret.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: api-key
type: Opaque
data:
  key: c3VwZXJzZWNyZXRhcGlrZXkxMjM=  # base64("supersecretapikey123")
EOF

echo "Secret in Git:"
echo "- Visible in Git history forever"
echo "- Accessible to anyone with repo access"
echo "- Shows up in GitHub search"
echo "- Rotated secrets still in history"

# Decode the "secret" from Git
echo "Decoded from Git:"
echo "c3VwZXJzZWNyZXRhcGlrZXkxMjM=" | base64 -d
echo ""
```{{exec}}

Secrets committed to Git live in history forever, even after deletion.
