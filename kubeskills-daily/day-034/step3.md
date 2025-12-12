## Step 3: Create ServiceAccounts and RBAC per team

```bash
# Team A - admin in their namespace
kubectl create serviceaccount team-a-admin -n team-a

cat <<'RBAC' | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: team-admin
  namespace: team-a
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: team-a-admin-binding
  namespace: team-a
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: team-admin
subjects:
- kind: ServiceAccount
  name: team-a-admin
  namespace: team-a
RBAC
```{{exec}}

Team A gets admin rights only in their namespace.
