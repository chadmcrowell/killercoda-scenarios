## Step 12: Test custom resource permissions

```bash
# Create CRD (from previous days)
cat <<EOF | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: databases.example.com
spec:
  group: example.com
  names:
    kind: Database
    plural: databases
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              engine:
                type: string
EOF

# Create Role for custom resource
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: database-operator
rules:
- apiGroups: ["example.com"]
  resources: ["databases"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: ["example.com"]
  resources: ["databases/status"]  # Status subresource
  verbs: ["get", "update", "patch"]
EOF

kubectl create serviceaccount db-operator-sa
kubectl create rolebinding db-operator-binding \
  --role=database-operator \
  --serviceaccount=default:db-operator-sa
```{{exec}}

Custom resources need their own RBAC rules and subresource verbs.
