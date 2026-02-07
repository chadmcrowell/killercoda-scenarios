## Step 9: Test secret in Git (anti-pattern)

```bash
# BAD: Secret checked into Git
cat > /tmp/gitops-repo/bad-secret.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: db-password
type: Opaque
data:
  password: cGFzc3dvcmQxMjM=  # base64("password123")
EOF

echo "Secrets in Git:"
echo "- Visible in Git history"
echo "- Accessible to anyone with repo access"
echo "- Can't rotate without Git commit"
echo ""
echo "Solution: Use SealedSecrets or external secret managers"
```{{exec}}

Understand why storing secrets directly in Git is a security anti-pattern and what alternatives exist.
