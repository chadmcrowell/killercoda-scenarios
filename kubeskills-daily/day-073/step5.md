## Step 5: Fix with namespace-scoped RBAC

```bash
# Delete bad ClusterRoleBinding
kubectl delete clusterrolebinding team-a-reader

# Create proper Role (namespace-scoped)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: tenant-reader
  namespace: team-a
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: tenant-a-reader
  namespace: team-a
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: tenant-reader
subjects:
- kind: ServiceAccount
  name: tenant-a-sa
  namespace: team-a
EOF

# Now team-a can ONLY access team-a
kubectl run good-access -n team-a --rm -it --image=curlimages/curl --restart=Never \
  --overrides='{"spec":{"serviceAccountName":"tenant-a-sa"}}' -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  echo "Trying to access team-b:"
  curl -k -H "Authorization: Bearer $TOKEN" \
    https://kubernetes.default.svc/api/v1/namespaces/team-b/pods 2>&1 | grep -o "forbidden"
'
```{{exec}}

Role and RoleBinding properly isolate namespace access.
