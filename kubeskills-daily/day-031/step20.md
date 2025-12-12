## Step 20: Test rollback

```bash
helm rollback myapp-release 1

helm history myapp-release
kubectl get deployment -l app.kubernetes.io/instance=myapp-release -o jsonpath='{.items[0].spec.replicas}'
```{{exec}}

Rollback returns to a previous release revision and replica count.
