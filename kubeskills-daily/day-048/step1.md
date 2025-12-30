## Step 1: Check current cluster version

```bash
kubectl version --short
kubectl version -o json | jq -r '.serverVersion.gitVersion'
kubectl get nodes -o wide
```{{exec}}

Check client, server, and node versions.
