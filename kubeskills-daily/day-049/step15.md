## Step 15: Check backup storage location

```bash
velero backup-location get
velero backup get
velero backup describe backup-test-ns --details
velero backup logs backup-test-ns | grep -i "error\|warning\|failed"
```{{exec}}

Inspect storage location and scan backups for warnings/errors.
