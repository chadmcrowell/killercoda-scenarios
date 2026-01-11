<br>

### RBAC misconfiguration lessons

**Key observations**

- get, list, and watch are independent permissions.
- Role scope is namespaced; ClusterRole scope is cluster-wide.
- Default ServiceAccount has no permissions by default.
- Subresources like pods/log need explicit RBAC rules.
- resourceNames limits access to specific objects.
- Aggregation combines rules from matching ClusterRoles.

**Production patterns**

```yaml
# Operator ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: myapp-operator
  namespace: myapp-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: myapp-operator
rules:
# Custom resources
- apiGroups: ["myapp.example.com"]
  resources: ["myapps"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: ["myapp.example.com"]
  resources: ["myapps/status"]
  verbs: ["get", "update", "patch"]
# Dependent resources
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["services", "configmaps"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
# Events
- apiGroups: [""]
  resources: ["events"]
  verbs: ["create", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: myapp-operator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: myapp-operator
subjects:
- kind: ServiceAccount
  name: myapp-operator
  namespace: myapp-system
```

```yaml
# Read-only developer access
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer-readonly
  namespace: development
rules:
- apiGroups: ["", "apps", "batch"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods/log", "pods/portforward"]
  verbs: ["get", "list"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]  # Allow kubectl exec for debugging
```

```yaml
# CI/CD ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cicd-deployer
  namespace: production
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: cicd-deployer
  namespace: production
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "create", "update", "patch"]
- apiGroups: [""]
  resources: ["services", "configmaps"]
  verbs: ["get", "list", "create", "update", "patch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get"]  # Read-only secrets
- apiGroups: ["batch"]
  resources: ["jobs"]
  verbs: ["get", "list", "create"]
```

```bash
# RBAC audit script
#!/bin/bash
# rbac-audit.sh

echo "=== RBAC Audit Report ==="

echo -e "\n1. ServiceAccounts with cluster-admin:"
kubectl get clusterrolebindings -o json | jq -r '
  .items[] | 
  select(.roleRef.name == "cluster-admin") | 
  .subjects[]? | 
  select(.kind == "ServiceAccount") | 
  "\(.namespace)/\(.name)"
'

echo -e "\n2. Roles with wildcard permissions:"
kubectl get roles,clusterroles -A -o json | jq -r '
  .items[] | 
  select(.rules[]? | .verbs[]? == "*") | 
  "\(.metadata.namespace // "cluster")/\(.metadata.name)"
'

echo -e "\n3. ServiceAccounts with no bindings:"
for sa in $(kubectl get sa -A -o json | jq -r '.items[] | "\(.metadata.namespace)/\(.metadata.name)"'); do
  ns=$(echo $sa | cut -d/ -f1)
  name=$(echo $sa | cut -d/ -f2)
  
  bindings=$(kubectl get rolebindings,clusterrolebindings -A -o json | jq -r "
    .items[] | 
    select(.subjects[]?.kind == \"ServiceAccount\" and .subjects[]?.name == \"$name\") | 
    .metadata.name
  ")
  
  if [ -z "$bindings" ]; then
    echo "  $sa (unused)"
  fi
done

echo -e "\n4. Overly permissive bindings:"
kubectl get clusterrolebindings -o json | jq -r '
  .items[] | 
  select(.subjects[]?.kind == "Group" and .subjects[]?.name == "system:authenticated") | 
  "\(.metadata.name): \(.roleRef.name)"
'
```

**Cleanup**

```bash
kubectl delete pod rbac-test limited-pod broken-operator cluster-test
kubectl delete sa limited-sa operator-sa cluster-sa specific-sa no-watch-sa logs-sa impersonator-sa wildcard-sa db-operator-sa deployer-sa
kubectl delete role pod-reader broken-operator-role specific-pod-only no-watch-role logs-reader wildcard-role database-operator deployer
kubectl delete rolebinding pod-reader-binding broken-operator-binding specific-binding no-watch-binding logs-binding wildcard-binding db-operator-binding deployer-binding
kubectl delete clusterrole cluster-pod-reader base-reader monitoring-reader impersonator
kubectl delete clusterrolebinding cluster-reader-binding impersonator-binding
kubectl delete crd databases.example.com
kubectl delete namespace other-ns
```{{exec}}

---

Next: Day 56 - Resource Exhaustion and Cluster Capacity
