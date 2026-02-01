## Key Observations

✅ **API deprecation** - 3 releases warning, then removed
✅ **PSP removed** - use Pod Security Standards instead
✅ **Version skew** - control plane can be N+1 ahead
✅ **Webhook versions** - must support current APIs
✅ **CRD updates** - may be needed before upgrade
✅ **One version at a time** - skipping versions unsupported

## Cleanup

```bash
kubectl delete ingress new-ingress 2>/dev/null
kubectl delete deployment new-deployment 2>/dev/null
kubectl delete cronjob new-cronjob 2>/dev/null
kubectl delete validatingwebhookconfiguration version-test-webhook 2>/dev/null
kubectl delete crd testcrds.example.com 2>/dev/null
kubectl delete service test-service 2>/dev/null
kubectl delete storageclass test-storage 2>/dev/null
kubectl label namespace default pod-security.kubernetes.io/enforce- 2>/dev/null
rm -f /tmp/*.yaml /tmp/upgrade-checklist.sh
```{{exec}}

---

**Next:** Day 73 - Multi-Tenancy Failures and Namespace Isolation
