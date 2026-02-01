## Step 7: Test backup corruption

```bash
# Corrupt backup file
echo "corrupted data" >> /tmp/backup-resources.yaml

# Try to restore
kubectl apply -f /tmp/backup-resources.yaml 2>&1 || echo "Backup corrupted!"

# Restore from clean backup
kubectl get all,configmap,secret,pvc -n backup-test -o yaml > /tmp/backup-resources.yaml
```{{exec}}

Corrupted backups fail to restore - validation is critical.
