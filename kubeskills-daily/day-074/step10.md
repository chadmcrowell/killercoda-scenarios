## Step 10: Test backup retention issues

```bash
# Create multiple backups
for i in {1..5}; do
  kubectl get all -n backup-test -o yaml > /tmp/backup-day-$i.yaml
  echo "Backup day $i"
done

# Simulate no cleanup (disk fills up)
du -sh /tmp/backup-*.yaml
echo "Without retention policy, backups accumulate forever"

# Manual cleanup
rm /tmp/backup-day-*.yaml
```{{exec}}

Backup retention policies prevent disk exhaustion.
