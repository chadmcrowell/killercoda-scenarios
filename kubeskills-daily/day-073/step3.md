## Step 3: Test cross-namespace access without RBAC

```bash
# Deploy app in team-a
kubectl run app-a -n team-a --image=nginx

# Create ServiceAccount in team-a
kubectl create serviceaccount tenant-a-sa -n team-a

# Try to access team-b from team-a pod
kubectl run access-test -n team-a --rm -it --image=curlimages/curl --restart=Never -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  curl -k -H "Authorization: Bearer $TOKEN" \
    https://kubernetes.default.svc/api/v1/namespaces/team-b/pods
' 2>&1 || echo "Access denied (good!)"
```{{exec}}

Default ServiceAccount has no cross-namespace permissions.
