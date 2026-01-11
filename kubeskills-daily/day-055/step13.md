## Step 13: Debug RBAC issues

```bash
# Check if SA can perform action
kubectl auth can-i create deployments --as=system:serviceaccount:default:limited-sa

# List all permissions for SA
kubectl auth can-i --list --as=system:serviceaccount:default:limited-sa

# Get RoleBindings for SA
kubectl get rolebindings -o json | jq -r '
  .items[] | 
  select(.subjects[]?.name == "limited-sa") | 
  "\(.metadata.name): \(.roleRef.name)"
'

# Check ClusterRoleBindings
kubectl get clusterrolebindings -o json | jq -r '
  .items[] | 
  select(.subjects[]?.name == "limited-sa") | 
  "\(.metadata.name): \(.roleRef.name)"
'
```{{exec}}

Use kubectl auth can-i and binding lookups to debug access issues.
