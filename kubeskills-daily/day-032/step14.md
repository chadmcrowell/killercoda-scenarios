## Step 14: Test prune behavior

```bash
# Enable prune
kubectl patch application demo-app -n argocd --type=merge -p '{
  "spec": {
    "syncPolicy": {
      "automated": {
        "prune": true,
        "selfHeal": true
      }
    }
  }
}'

# Create resource manually
kubectl create configmap manual-cm --from-literal=key=value

# Wait for sync
sleep 10

# Check if pruned
kubectl get configmap manual-cm 2>&1 || echo "Pruned by ArgoCD"
```{{exec}}

Prune removes resources not defined in Git.
