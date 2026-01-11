## Step 10: Test impersonation permissions

```bash
# Create Role that allows impersonation
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: impersonator
rules:
- apiGroups: [""]
  resources: ["users", "groups", "serviceaccounts"]
  verbs: ["impersonate"]
EOF

kubectl create serviceaccount impersonator-sa
kubectl create clusterrolebinding impersonator-binding \
  --clusterrole=impersonator \
  --serviceaccount=default:impersonator-sa

# Test impersonation
kubectl auth can-i impersonate users --as=system:serviceaccount:default:impersonator-sa
```{{exec}}

Impersonation requires explicit RBAC permissions.
