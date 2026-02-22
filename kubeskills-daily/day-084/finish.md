## Key Observations

✅ **Controller required** - Ingress is just configuration without one
✅ **IngressClass** - selects which controller processes each Ingress
✅ **Path types** - Exact vs Prefix behavior differs significantly
✅ **TLS secrets** - must be in the same namespace as the Ingress
✅ **Backend endpoints** - service needs ready pods or traffic 503s
✅ **Annotations** - controller-specific, silently ignored by others

## Cleanup

```bash
kubectl delete ingress --all 2>/dev/null
kubectl delete ingress --all -n other-ns 2>/dev/null
kubectl delete deployment web-app api-app 2>/dev/null
kubectl delete service web-service api-service no-endpoints-service 2>/dev/null
kubectl delete secret example-tls 2>/dev/null
kubectl delete namespace other-ns 2>/dev/null
rm -f /tmp/*.yaml /tmp/*.md
```{{exec}}

---

**Congratulations!** You've completed Day 84 of Kubernetes failure scenarios!
