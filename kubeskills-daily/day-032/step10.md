## Step 10: Fix and retry

```bash
rm broken.yaml

# Sync succeeds
argocd app sync demo-app
```{{exec}}

With the bad file removed, sync should work again.
