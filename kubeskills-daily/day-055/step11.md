## Step 11: Test wildcard permissions

```bash
# Create Role with wildcards (dangerous!)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: wildcard-role
rules:
- apiGroups: ["*"]  # All API groups
  resources: ["*"]  # All resources
  verbs: ["*"]      # All verbs
EOF

kubectl create serviceaccount wildcard-sa
kubectl create rolebinding wildcard-binding \
  --role=wildcard-role \
  --serviceaccount=default:wildcard-sa

# This SA can do anything in the namespace!
kubectl auth can-i delete secrets --as=system:serviceaccount:default:wildcard-sa
```{{exec}}

Wildcards grant far more than intended.
