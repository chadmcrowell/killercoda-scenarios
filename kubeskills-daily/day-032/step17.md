## Step 17: Test selective sync

```bash
# Sync only specific resource
argocd app sync demo-app --resource=Service:default/demo-app
```{{exec}}

Targets a single resource rather than the full app.
