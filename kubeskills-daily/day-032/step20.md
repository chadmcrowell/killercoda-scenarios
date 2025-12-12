## Step 20: Test app deletion with cascade

```bash
# Delete app (keeps resources)
argocd app delete demo-app --cascade=false

# Resources still there
kubectl get deployment demo-app

# Delete with cascade
kubectl delete application demo-app -n argocd

# Deployment deleted too
kubectl get deployment demo-app 2>&1 || echo "Deployment deleted"
```{{exec}}

Shows the difference between non-cascading and cascading deletes.
