## Step 1: Check default ServiceAccount permissions

```bash
# Create test pod with default ServiceAccount
kubectl run rbac-test --image=nginx

# Try to access API from pod
kubectl exec rbac-test -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  curl -k -H "Authorization: Bearer $TOKEN" \
    https://kubernetes.default.svc/api/v1/namespaces/default/pods
' 2>&1 || echo "Default SA has no permissions!"
```{{exec}}

Default ServiceAccount has no permissions by default.
