## Step 3: Test incomplete backup

```bash
# Backup only some resources
kubectl get deployment,service -n backup-test -o yaml > /tmp/incomplete-backup.yaml

# Missing: StatefulSet, PVC, Secrets, ConfigMaps
grep "kind:" /tmp/incomplete-backup.yaml
```{{exec}}

Incomplete backups missing critical resources.
