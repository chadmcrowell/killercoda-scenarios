<br>

### Cluster upgrade lessons

**Key observations**

- Version skew rules: kubelets N-2..N vs apiserver N; kubectl ±1 minor.
- Deprecated/alpha APIs can break after upgrades—identify and migrate early.
- CRDs need served/storage versions aligned before upgrading.
- Webhooks and feature gates must target supported versions.
- Storage version migration may be required when APIs change.
- Upgrade one minor version at a time with backups and pre-checks.

**Production patterns**

```bash
kubectl version --short
kubectl get nodes -o custom-columns=NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion
kubectl api-resources | grep -E "beta|alpha"
```

```bash
./pluto detect-all-in-cluster --target-versions k8s=v1.29.0
```

```yaml
admissionReviewVersions: ["v1", "v1beta1"]
```

**Cleanup**

```bash
kubectl delete deployment api-version-test
kubectl delete crd crontabs.stable.example.com
kubectl delete crontab test-crontab 2>/dev/null
kubectl delete validatingwebhookconfiguration version-test-webhook
kubectl delete service legacy-service
rm -f /tmp/check-deprecated.sh /tmp/upgrade-precheck.sh /tmp/upgrade-plan.md
```{{exec}}

---

Next: Day 49 - Backup and Restore Failures with Velero
