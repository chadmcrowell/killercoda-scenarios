## Key Observations

✅ **Default limits** - 400 QPS per user
✅ **APF queuing** - prioritizes system requests
✅ **Watch connections** - each is long-lived
✅ **List operations** - expensive at scale
✅ **Client throttling** - kubectl self-limits
✅ **Cloud provider limits** - separate from Kubernetes

## Cleanup

```bash
kubectl delete configmap $(kubectl get cm -o name | grep spam) 2>/dev/null
kubectl delete deployment many-pods chatty-controller 2>/dev/null
rm -f /tmp/*.sh /tmp/*.yaml /tmp/*.md /tmp/*.go
```{{exec}}

---

**Congratulations!** You've completed 80 days of Kubernetes failure scenarios!
