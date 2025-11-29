## Step 12: Test aggregated ClusterRoles

```bash
kubectl describe clusterrole view | head -30
kubectl describe clusterrole edit | head -30
kubectl describe clusterrole admin | head -30
```{{exec}}

Built-in ClusterRoles are aggregated from multiple rules—inspect what they include.
