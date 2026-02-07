## Step 6: Secret without RBAC protection

```bash
# Create service account
kubectl create serviceaccount app-sa

# Deploy pod with ServiceAccount
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-reader
spec:
  serviceAccountName: app-sa
  containers:
  - name: app
    image: bitnami/kubectl
    command: ['sleep', '3600']
EOF

kubectl wait --for=condition=Ready pod secret-reader --timeout=60s

# Try to read secrets (fails without RBAC)
kubectl exec secret-reader -- kubectl get secrets 2>&1 || echo "Access denied (good!)"

# Grant access (bad idea in production)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: secret-reader-role
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: secret-reader-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: secret-reader-role
subjects:
- kind: ServiceAccount
  name: app-sa
EOF

# Now pod can read all secrets!
kubectl exec secret-reader -- kubectl get secrets
kubectl exec secret-reader -- kubectl get secret db-creds -o jsonpath='{.data.password}' | base64 -d
```{{exec}}

Without proper RBAC, any pod with broad secret access can read all secrets in the namespace.
