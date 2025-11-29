<br>

### Lockout lifted

**Key observations**

✅ ServiceAccounts start nearly powerless—bindings grant the keys.  
✅ Role vs ClusterRole = namespace vs cluster scope; RoleBinding scopes the ref.  
✅ Subresources (pods/log, deployments/scale) and resourceNames need explicit rules.  
✅ Aggregated ClusterRoles compose via labels—watch what gets pulled in.  
✅ `kubectl auth can-i` is the fastest way to prove or deny permissions.

**Production patterns**

CI/CD ServiceAccount:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: deployer
rules:
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets"]
  verbs: ["get", "list", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["services", "configmaps", "secrets"]
  verbs: ["get", "list", "create", "update", "patch", "delete"]
- apiGroups: ["batch"]
  resources: ["jobs", "cronjobs"]
  verbs: ["get", "list", "create", "update", "patch", "delete"]
```

Monitoring ServiceAccount:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources: ["nodes", "nodes/metrics", "services", "endpoints", "pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get"]
- nonResourceURLs: ["/metrics", "/metrics/cadvisor"]
  verbs: ["get"]
```

App with minimum permissions:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-minimal
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["app-config"]
  verbs: ["get"]
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["app-secrets"]
  verbs: ["get"]
```

**Cleanup**

```bash
kubectl delete namespace rbac-test app-team
kubectl delete clusterrole pod-reader-cluster monitoring monitoring-reader 2>/dev/null
kubectl delete clusterrolebinding read-pods-global 2>/dev/null
```{{exec}}

---

Next: Day 17 - Admission Webhook Timeouts
