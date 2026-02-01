## Key Observations

✅ **CRD validation** - enforced at API server level
✅ **Finalizers** - block deletion until removed
✅ **RBAC required** - operator needs permissions for all managed resources
✅ **Status subresource** - separate from spec updates
✅ **Operator crashes** - leave resources in unknown state
✅ **CRD deletion** - blocked by existing CRs

## Cleanup

```bash
kubectl delete namespace webapp-system 2>/dev/null
kubectl delete crd webapps.example.com multiversions.example.com 2>/dev/null
kubectl delete clusterrole webapp-operator 2>/dev/null
kubectl delete clusterrolebinding webapp-operator 2>/dev/null
rm -f /tmp/operator-diagnosis.sh
```{{exec}}

---

**Next:** Day 72 - Cluster Upgrade Failures and Version Skew
