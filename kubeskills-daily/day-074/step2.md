## Step 2: Backup namespace resources (NOT PVs)

```bash
# Backup all resources in namespace
kubectl get all,configmap,secret,pvc -n backup-test -o yaml > /tmp/backup-resources.yaml

# Check what was backed up
grep "kind:" /tmp/backup-resources.yaml | sort | uniq

echo "Note: PV data (database contents) NOT backed up!"
```{{exec}}

Kubernetes resources backed up, but PV data is NOT included.
