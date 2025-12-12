## Step 8: Enable auto-sync and self-heal

```bash
kubectl patch application demo-app -n argocd --type=merge -p '{
  "spec": {
    "syncPolicy": {
      "automated": {
        "prune": false,
        "selfHeal": true
      }
    }
  }
}'

# Watch it revert to 2 replicas
kubectl get deployment demo-app -w
```{{exec}}

Self-heal should restore replicas to the Git state.
