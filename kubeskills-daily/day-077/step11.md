## Step 11: Test SealedSecret (proper way)

```bash
# Conceptual: SealedSecret workflow
cat > /tmp/sealed-secret-example.yaml << 'EOF'
# 1. Create secret locally
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  password: c3VwZXJzZWNyZXQ=

# 2. Encrypt with kubeseal (one-way)
# kubeseal < secret.yaml > sealed-secret.yaml

# 3. SealedSecret (safe to commit to Git)
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: mysecret
spec:
  encryptedData:
    password: AgBX7VvO3D... (encrypted, safe in Git)

# 4. Controller decrypts in cluster only
# Creates Secret automatically
# Only cluster can decrypt
EOF

cat /tmp/sealed-secret-example.yaml

echo ""
echo "SealedSecret benefits:"
echo "- Encrypted at rest in Git"
echo "- Only cluster can decrypt"
echo "- Asymmetric encryption (one-way)"
```{{exec}}

SealedSecrets encrypt secrets so they are safe to store in Git - only the cluster can decrypt them.
