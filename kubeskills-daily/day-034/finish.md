<br>

### Namespace isolation enforced

**Key observations**

✅ Namespaces alone aren't isolation—NetworkPolicy, RBAC, PSA, and quotas add boundaries.  
✅ NetworkPolicies block cross-namespace traffic while allowing same-namespace and DNS.  
✅ ResourceQuotas/LimitRanges cap resource use and set defaults.  
✅ RBAC stops cross-namespace access even with tokens; PSA blocks privileged pods.

**Production patterns**

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: tenant-{{.TenantName}}
  labels:
    tenant: {{.TenantName}}
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/warn: restricted
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tenant-quota
  namespace: tenant-{{.TenantName}}
spec:
  hard:
    requests.cpu: "10"
    requests.memory: "20Gi"
    limits.cpu: "20"
    limits.memory: "40Gi"
    pods: "50"
    services: "20"
    persistentvolumeclaims: "10"
---
apiVersion: v1
kind: LimitRange
metadata:
  name: tenant-limits
  namespace: tenant-{{.TenantName}}
spec:
  limits:
  - max:
      cpu: "2"
      memory: "4Gi"
    default:
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:
      cpu: "100m"
      memory: "128Mi"
    type: Container
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-cross-namespace
  namespace: tenant-{{.TenantName}}
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector: {}
  egress:
  - to:
    - podSelector: {}
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
```

**Cleanup**

```bash
kubectl delete namespace team-a team-b team-c team-a-dev
```{{exec}}

---

Next: Day 35 - TBD
