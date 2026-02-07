## Step 2: Decode secret (trivially easy)

```bash
# Anyone with kubectl access can decode
kubectl get secret db-creds -o jsonpath='{.data.password}' | base64 -d
echo ""

echo "Secrets are base64 encoded, NOT encrypted!"
echo "base64 is encoding, not encryption"
```{{exec}}

Demonstrate that base64 encoding provides zero security - anyone with kubectl access can decode secrets instantly.
