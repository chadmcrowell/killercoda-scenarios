## Step 15: Document disaster recovery procedure

```bash
cat > /tmp/etcd-dr-plan.md << 'EOF'
# etcd Disaster Recovery Plan

## Backup Procedure (Daily)
ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-$(date +%Y%m%d).db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

## Recovery from Snapshot
1. Stop kube-apiserver
2. Restore snapshot to new data directory
3. Update etcd to use new data directory
4. Start etcd
5. Start kube-apiserver
6. Verify cluster state

## Recovery from Quorum Loss
- If quorum lost but data intact: restore from healthy member
- If data corrupted: restore from latest snapshot (some data loss)
- RTO: 15-30 minutes
- RPO: Last successful backup (24 hours max)

## Monitoring
- Alert on etcd_server_has_leader == 0
- Alert on etcd_disk_wal_fsync_duration_seconds > 100ms
- Alert on etcd database size > 7GB
EOF

cat /tmp/etcd-dr-plan.md
```{{exec}}

Write a simple DR plan for etcd backups and restores.
