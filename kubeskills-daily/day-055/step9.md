## Step 9: Test subresource permissions

```bash
# Create Role with logs access
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: logs-reader
rules:
- apiGroups: [""]
  resources: ["pods/log"]  # Subresource!
  verbs: ["get"]
EOF

kubectl create serviceaccount logs-sa
kubectl create rolebinding logs-binding \
  --role=logs-reader \
  --serviceaccount=default:logs-sa

# Test - can read logs but not pod details
kubectl auth can-i get pods/log --as=system:serviceaccount:default:logs-sa
kubectl auth can-i get pods --as=system:serviceaccount:default:logs-sa
```{{exec}}

Subresources like pods/log need explicit permissions.
