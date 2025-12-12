<br>

### Istio traffic split debugged

**Key observations**

✅ DestinationRules define subsets; VirtualServices route by weight/headers/URIs.  
✅ Missing subsets lead to 503s; Istio normalizes weights that exceed 100.  
✅ Rule order matters—first match wins; retries/timeouts shape resiliency.  
✅ Sidecar logs and `istioctl analyze` surface routing and config issues.

**Production patterns**

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: webapp-canary
spec:
  hosts:
  - webapp
  http:
  - route:
    - destination:
        host: webapp
        subset: stable
      weight: 90
    - destination:
        host: webapp
        subset: canary
      weight: 10
```

**Cleanup**

```bash
kubectl delete virtualservice webapp
kubectl delete destinationrule webapp
kubectl delete deployment webapp-v1 webapp-v2 webapp-v3-slow
kubectl delete service webapp
istioctl uninstall --purge -y
kubectl delete namespace istio-system
kubectl label namespace default istio-injection-
cd ..
rm -rf istio-1.20.0
```{{exec}}

---

Next: Day 34 - Multi-Tenancy Namespace Isolation Failures
