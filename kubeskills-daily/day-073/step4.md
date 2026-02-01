## Step 4: Create overly permissive RBAC

```bash
# Bad: ClusterRole with access to all namespaces
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: tenant-reader
rules:
- apiGroups: [""]
  resources: ["pods", "services", "secrets"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: team-a-reader
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tenant-reader
subjects:
- kind: ServiceAccount
  name: tenant-a-sa
  namespace: team-a
EOF

# Now team-a can access team-b!
kubectl run bad-access -n team-a --rm -it --image=curlimages/curl --restart=Never \
  --overrides='{"spec":{"serviceAccountName":"tenant-a-sa"}}' -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  echo "Accessing team-b secrets:"
  curl -s -k -H "Authorization: Bearer $TOKEN" \
    https://kubernetes.default.svc/api/v1/namespaces/team-b/secrets | \
    grep -o "\"name\":\"[^\"]*\"" | head -3
'
```{{exec}}

ClusterRoleBinding breaks tenant isolation!
