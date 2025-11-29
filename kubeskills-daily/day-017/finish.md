<br>

### Webhooks behaving

**Key observations**

✅ `failurePolicy: Fail` blocks the cluster when webhooks are down; `Ignore` bypasses.  
✅ `timeoutSeconds` matters—default 10s makes failures feel like hangs.  
✅ `namespaceSelector` and `objectSelector` let you exempt or target workloads.  
✅ Webhooks need reachable services and valid CA bundles—TLS wiring must match.  
✅ Debug via API server logs and direct curls to the webhook service.

**Production patterns**

Safe webhook defaults:

```yaml
webhooks:
- name: safe.example.com
  failurePolicy: Ignore
  timeoutSeconds: 5
  namespaceSelector:
    matchExpressions:
    - key: admission-control
      operator: NotIn
      values: ["disabled"]
  sideEffects: None
  reinvocationPolicy: Never
```

Critical security webhook:

```yaml
webhooks:
- name: security.example.com
  failurePolicy: Fail
  timeoutSeconds: 3
  namespaceSelector:
    matchExpressions:
    - key: kubernetes.io/metadata.name
      operator: NotIn
      values: ["kube-system", "kube-public"]
```

Development exemption pattern:

```yaml
namespaceSelector:
  matchExpressions:
  - key: environment
    operator: In
    values: ["production", "staging"]
# Dev namespaces bypass the webhook
```

**Cleanup**

```bash
kubectl delete validatingwebhookconfiguration broken-webhook safe-webhook working-webhook labeled-webhook 2>/dev/null
kubectl delete deployment simple-webhook 2>/dev/null
kubectl delete service webhook-svc 2>/dev/null
kubectl delete pod test-pod test-pod2 2>/dev/null
kubectl delete namespace test-app prod-app 2>/dev/null
rm -f /tmp/key.pem /tmp/cert.pem
```{{exec}}

---

Next: Day 18 - CronJob Concurrency Policy Chaos
