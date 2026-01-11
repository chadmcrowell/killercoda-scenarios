## Step 2: Create ServiceAccount with limited permissions

```bash
# Create ServiceAccount
kubectl create serviceaccount limited-sa

# Create Role with only 'get' permission
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get"]  # Only get, no list!
EOF

# Bind Role to ServiceAccount
kubectl create rolebinding pod-reader-binding \
  --role=pod-reader \
  --serviceaccount=default:limited-sa
```{{exec}}

Create a ServiceAccount that can only get pods, not list them.
