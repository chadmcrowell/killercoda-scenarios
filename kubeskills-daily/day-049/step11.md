## Step 11: Test restore conflict

```bash
velero restore create restore-conflict \
  --from-backup backup-test-ns \
  --wait

velero restore describe restore-conflict --details
```{{exec}}

Expect AlreadyExists errors when restoring over existing resources.
