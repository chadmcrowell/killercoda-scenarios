## Key Observations

✅ **Image tags mutable** - 'latest' can change
✅ **Typosquatting** - common attack vector
✅ **Base image compromise** - affects all derived images
✅ **Dependency confusion** - public packages override private
✅ **No verification** - trust without validation
✅ **Build secrets exposure** - visible in image layers

## Cleanup

```bash
kubectl delete pod test-latest unverified-image 2>/dev/null
kubectl delete deployment unscanned-app 2>/dev/null
rm -f /tmp/*.txt /tmp/*.yaml /tmp/*.md /tmp/*.sh /tmp/*.js /tmp/*-dockerfile /tmp/package.json
```{{exec}}

---

**Congratulations!** You've completed 79 days of Kubernetes failure scenarios!
