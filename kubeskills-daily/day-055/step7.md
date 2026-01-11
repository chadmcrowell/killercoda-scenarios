## Step 7: Test missing watch permission

```bash
# Create Role without watch
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: no-watch-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]  # No watch!
EOF

kubectl create serviceaccount no-watch-sa
kubectl create rolebinding no-watch-binding \
  --role=no-watch-role \
  --serviceaccount=default:no-watch-sa

# Operators need 'watch' to get real-time updates
kubectl auth can-i watch pods --as=system:serviceaccount:default:no-watch-sa
```{{exec}}

Missing watch breaks controllers that depend on event streams.
