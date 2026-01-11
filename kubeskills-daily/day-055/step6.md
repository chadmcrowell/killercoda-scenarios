## Step 6: Test resourceNames restriction

```bash
# Create Role that only allows access to specific pod
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: specific-pod-only
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "delete"]
  resourceNames: ["rbac-test"]  # Only this pod!
EOF

kubectl create serviceaccount specific-sa
kubectl create rolebinding specific-binding \
  --role=specific-pod-only \
  --serviceaccount=default:specific-sa

# Test access
kubectl auth can-i get pod rbac-test --as=system:serviceaccount:default:specific-sa
kubectl auth can-i get pod limited-pod --as=system:serviceaccount:default:specific-sa
```{{exec}}

resourceNames allow access to only specific resource instances.
