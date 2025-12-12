## Step 6: Manual sync

```bash
argocd app sync demo-app
```{{exec}}

Verify resources created:

```bash
kubectl get deployment demo-app
kubectl get service demo-app
```{{exec}}
