## Step 5: Check Application status

```bash
kubectl get application -n argocd demo-app

argocd app get demo-app
```{{exec}}

Should show OutOfSync (cluster differs from Git).
