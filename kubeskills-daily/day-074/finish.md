## Key Observations

✅ **etcd ≠ PV data** - both needed for full restore
✅ **Test restores** - backups useless if not validated
✅ **Point-in-time** - requires continuous backups or WAL
✅ **Retention policy** - prevents disk exhaustion
✅ **Cross-region** - protects against regional failure
✅ **RTO = restore time** - not backup time

## Cleanup

```bash
kubectl delete namespace backup-test dr-test 2>/dev/null
kubectl delete cronjob backup-job -n backup-test 2>/dev/null
rm -f /tmp/backup-*.yaml /tmp/db-backup-*.sql /tmp/*.sh /tmp/backup-strategy.md /tmp/cluster-backup-*.yaml
```{{exec}}

---

**Next:** Day 75 - Observability Failures and Missing Metrics
