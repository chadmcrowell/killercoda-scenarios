## Step 14: Secret in backup

```bash
# Backup namespace
kubectl get secrets -o yaml > /tmp/secrets-backup.yaml

# Backup contains all secrets in plain(base64)
cat /tmp/secrets-backup.yaml | grep "password:"

echo "Secrets in backups:"
echo "- Base64 encoded"
echo "- Easily decoded"
echo "- Must encrypt backup files"
echo "- Secure backup storage critical"
```{{exec}}

Cluster backups contain all secrets in base64 - backup files must be encrypted and access-controlled.
