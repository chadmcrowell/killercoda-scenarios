<br>

### Velero backup/restore lessons

**Key observations**

- Volume snapshots require a provider; without them PVC data is lost.
- emptyDir data is ephemeral and not backed up.
- Restores conflict if resources already exist; use selectors or delete first.
- Hooks enable app-consistent backups; schedules enforce regular runs.
- Label selectors allow selective backups; exclusions skip noisy resources.
- Always inspect backup logs for warnings/errors and storage location health.

**Production patterns**

```bash
velero backup create production-backup \
  --include-namespaces production \
  --include-cluster-resources=true \
  --snapshot-volumes \
  --ttl 720h \
  --labels environment=production
```

```bash
velero schedule create nightly \
  --schedule="0 1 * * *" \
  --include-namespaces production,staging \
  --ttl 2160h \
  --include-cluster-resources=true
```

```yaml
# Database pod with Velero hooks
annotations:
  pre.hook.backup.velero.io/container: postgres
  pre.hook.backup.velero.io/command: '["/bin/bash","-c","pg_dump -U postgres -d app > /backup/dump.sql"]'
  post.hook.backup.velero.io/container: postgres
  post.hook.backup.velero.io/command: '["/bin/bash","-c","echo Backup complete"]'
```

**Cleanup**

```bash
velero backup delete --all --confirm
velero schedule delete --all --confirm
kubectl delete namespace backup-test
velero uninstall --force
kubectl delete namespace velero
rm -f velero-v1.12.0-linux-amd64.tar.gz
```{{exec}}

---

Next: Day 50 - Node Failures and Pod Eviction Storms
