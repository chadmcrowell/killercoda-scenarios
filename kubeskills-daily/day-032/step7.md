## Step 7: Cause OutOfSync - manual kubectl change

```bash
# Manually scale deployment
kubectl scale deployment demo-app --replicas=5

# Check ArgoCD status
argocd app get demo-app
```{{exec}}

Manual drift triggers OutOfSync status.
