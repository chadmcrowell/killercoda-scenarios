## Step 5: Create backup of namespace

```bash
velero backup create backup-test-ns \
  --include-namespaces backup-test \
  --wait

velero backup describe backup-test-ns
velero backup logs backup-test-ns | head -50
```{{exec}}

Create a full namespace backup and inspect its status/logs.
