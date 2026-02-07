## Key Observations

✅ **Sync failures** - invalid manifests block deployment
✅ **Auto-sync** - dangerous with bad manifests
✅ **Pruning** - deletes resources not in Git
✅ **Health checks** - determine sync success
✅ **Drift** - manual changes cause out-of-sync
✅ **Webhooks** - auth failures block automation

## Cleanup

```bash
kubectl delete namespace gitops-test 2>/dev/null
rm -rf /tmp/gitops-repo /tmp/webhook-config.yaml /tmp/*.yaml /tmp/*.md
```{{exec}}

---

**Congratulations!** You've completed 76 days of Kubernetes failure scenarios!
