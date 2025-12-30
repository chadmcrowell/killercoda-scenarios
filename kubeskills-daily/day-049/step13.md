## Step 13: Test scheduled backups

```bash
velero schedule create daily-backup \
  --schedule="0 2 * * *" \
  --include-namespaces backup-test \
  --ttl 168h

velero schedule get
velero backup create --from-schedule daily-backup --wait
```{{exec}}

Schedules recurring backups and triggers a run.
