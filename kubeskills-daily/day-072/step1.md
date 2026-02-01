## Step 1: Check current cluster version

```bash
# Get cluster version
kubectl version --short

# Get server version details
kubectl version -o json | jq -r '.serverVersion'

# Check node versions
kubectl get nodes -o wide
```{{exec}}

Verify the current Kubernetes version across the cluster.
