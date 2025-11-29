## Step 11: RoleBinding with ClusterRole (namespace-scoped use)

```bash
kubectl create namespace app-team
kubectl create serviceaccount app-sa -n app-team
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: app-team
subjects:
- kind: ServiceAccount
  name: app-sa
  namespace: app-team
roleRef:
  kind: ClusterRole
  name: view  # Built-in ClusterRole
  apiGroup: rbac.authorization.k8s.io
EOF
```{{exec}}

RoleBinding can reference a ClusterRole but scope the access to a namespace.
