## Step 19: Rollback via ArgoCD

```bash
# Get history
REVISION=$(argocd app history demo-app | grep -v REVISION | head -1 | awk '{print $1}')

# Rollback
argocd app rollback demo-app $REVISION
```{{exec}}

Rollback to a chosen revision.
