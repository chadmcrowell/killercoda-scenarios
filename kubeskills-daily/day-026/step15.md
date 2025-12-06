## Step 15: Recovery after eviction

```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[0].restartCount
kubectl get deployment protected-app
kubectl get pods -l app=protected
```{{exec}}

Deployments recreate evicted pods; check restart counts and replicas.
