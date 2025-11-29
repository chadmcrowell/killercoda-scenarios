## Step 5: Check eviction timing

```bash
kubectl describe pod $(kubectl get pods -l app=default-app -o jsonpath='{.items[0].metadata.name}') | grep -A 5 Events
```{{exec}}

Events show `node.kubernetes.io/not-ready` toleration exceeded and eviction timing.
