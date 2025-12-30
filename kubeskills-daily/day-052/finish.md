<br>

### etcd corruption and quorum lessons

**Key observations**

- etcd needs quorum (N/2 + 1) for reads/writes; losing quorum freezes the cluster.
- Snapshots are critical for recovery from corruption or quorum loss.
- Compaction/defrag keeps DB size under quota and reduces fragmentation.
- Alarms (e.g., NOSPACE) warn before failure; monitor metrics for latency and size.
- Restoring snapshots requires downtime and careful steps; test procedures ahead.
- Disk performance directly impacts etcd health and API responsiveness.

**Production patterns**

```bash
ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-$(date +%Y%m%d).db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```

```yaml
# Prometheus alerts
- alert: etcdNoLeader
  expr: etcd_server_has_leader == 0
  for: 1m
- alert: etcdHighFsyncDuration
  expr: histogram_quantile(0.99, rate(etcd_disk_wal_fsync_duration_seconds_bucket[5m])) > 0.5
  for: 10m
- alert: etcdDatabaseSizeLimit
  expr: etcd_mvcc_db_total_size_in_bytes > 7516192768
```

```bash
# Hash/health check
ETCDCTL_API=3 etcdctl endpoint health
ETCDCTL_API=3 etcdctl endpoint hash
```

**Cleanup**

```bash
kubectl delete configmap $(kubectl get cm -o name | grep load-test-) 2>/dev/null
rm -f etcd-backup.db /tmp/etcd-dr-plan.md
```{{exec}}

---

Next: Day 53 - Network Partition (Split-Brain) Scenarios
