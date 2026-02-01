## Step 14: Test backup monitoring

```bash
# Check backup job status
kubectl get jobs -n backup-test

# Check for failed backups
kubectl get events -n backup-test --sort-by='.lastTimestamp' | grep -i backup

# Simulate alerting on backup failure
cat > /tmp/check-backup.sh << 'EOF'
#!/bin/bash
# Check if backup is recent

BACKUP_FILE="/tmp/backup-resources.yaml"
MAX_AGE_HOURS=24

if [ ! -f "$BACKUP_FILE" ]; then
  echo "CRITICAL: Backup file missing"
  exit 2
fi

AGE=$(( ($(date +%s) - $(stat -f %m "$BACKUP_FILE" 2>/dev/null || stat -c %Y "$BACKUP_FILE")) / 3600 ))

if [ $AGE -gt $MAX_AGE_HOURS ]; then
  echo "CRITICAL: Backup is $AGE hours old"
  exit 2
fi

echo "OK: Backup is $AGE hours old"
exit 0
EOF

chmod +x /tmp/check-backup.sh
/tmp/check-backup.sh
```{{exec}}

Monitoring backup age and success is critical.
