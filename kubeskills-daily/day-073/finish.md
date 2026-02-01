## Key Observations

✅ **Namespaces ≠ security boundaries** - RBAC required
✅ **ResourceQuota** - per namespace, but nodes shared
✅ **NetworkPolicy** - blocks pod traffic, not API access
✅ **RBAC scope** - Use Role (namespace) not ClusterRole
✅ **Noisy neighbor** - resource contention on shared nodes
✅ **Priority preemption** - can evict other tenants

## Cleanup

```bash
kubectl delete namespace team-a team-b team-c delete-test 2>/dev/null
kubectl delete clusterrole tenant-reader 2>/dev/null
kubectl delete clusterrolebinding team-a-reader 2>/dev/null
kubectl delete priorityclass tenant-critical 2>/dev/null
NODE=$(kubectl get nodes -o name | head -1 | cut -d'/' -f2)
kubectl label node $NODE tenant- 2>/dev/null
rm -f /tmp/tenant-diagnosis.sh
```{{exec}}

---

**Next:** Day 74 - Backup and Restore Disasters
