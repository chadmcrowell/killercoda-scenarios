## Step 8: Test backup without validation

```bash
# Create backup script that doesn't validate
cat > /tmp/bad-backup.sh << 'EOF'
#!/bin/bash
# Bad backup - no validation!

kubectl get all -A -o yaml > /tmp/cluster-backup-$(date +%Y%m%d).yaml
echo "Backup complete!"
# Never checks if backup succeeded or is valid
EOF

chmod +x /tmp/bad-backup.sh
/tmp/bad-backup.sh

# Check if backup is actually usable
kubectl apply --dry-run=client -f /tmp/cluster-backup-*.yaml 2>&1 | head -20
```{{exec}}

Backups without validation may be unusable when needed.
