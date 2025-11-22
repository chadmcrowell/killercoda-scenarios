<br>

### DNS finally caught up

**Key observations**

✅ Service DNS typically appears within a few seconds once endpoints exist.  
✅ Endpoints only populate after pods pass readiness probes.  
✅ Headless services return pod IPs directly—ClusterIP returns a virtual IP.  
✅ Long-lived clients or connection pools may stick to stale IPs during rollouts.  
✅ `ndots`, timeouts, and attempts tune lookup behavior and latency.

**Production patterns**

Reduce DNS lookup latency:

```yaml
dnsConfig:
  options:
  - name: ndots
    value: "2"
```

Mesh/sidecar for connection management:

- Istio/Linkerd handle retries and endpoint refreshing during pod churn.

ExternalName for external services:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: db.example.com
```

**Cleanup**

```bash
kubectl delete pod dns-timing-test init-dns-test dns-policy-test client 2>/dev/null
kubectl delete service backend-svc backend-headless 2>/dev/null
kubectl delete deployment backend 2>/dev/null
```{{exec}}

---

Next: Day 12 - HPA Thrashing
