## Step 3: Create operator deployment (simplified)

```bash
# Conceptual RBAC setup for the operator
cat <<'RBAC' | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: webapp-operator
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: webapp-operator
rules:
- apiGroups: ["apps.example.com"]
  resources: ["webapps", "webapps/status"]
  verbs: ["get", "list", "watch", "update", "patch"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: webapp-operator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: webapp-operator
subjects:
- kind: ServiceAccount
  name: webapp-operator
  namespace: default
RBAC
```{{exec}}

RBAC is in place; the operator script would run with this service account.
