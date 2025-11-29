## Step 16: Test resource names restriction

```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: specific-secret-reader
  namespace: rbac-test
rules:
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["my-secret"]  # Only this specific secret!
  verbs: ["get"]
EOF
```{{exec}}

ResourceNames limit access to specific objects instead of all in the resource type.
