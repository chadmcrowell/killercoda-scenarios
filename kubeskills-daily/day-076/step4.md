## Step 4: Test resource pruning danger

```bash
# Deploy initial resources
kubectl create namespace gitops-test
kubectl apply -f /tmp/gitops-repo/base/deployment.yaml -n gitops-test
kubectl apply -f /tmp/gitops-repo/base/service.yaml -n gitops-test

# Check resources
kubectl get all -n gitops-test

# Simulate pruning: Remove service from Git
rm /tmp/gitops-repo/base/service.yaml
sed -i '/service.yaml/d' /tmp/gitops-repo/base/kustomization.yaml

echo "With auto-prune enabled:"
echo "- Service would be DELETED from cluster"
echo "- Even though it's needed by deployment"
echo "- Can cause production outages"
```{{exec}}

Understand the danger of auto-pruning: removing a manifest from Git causes the live resource to be deleted.
