## Step 19: Test upgrade

```bash
helm upgrade myapp-release ./myapp --set replicaCount=3

helm history myapp-release
```{{exec}}

Upgrade increases replicas and records a new revision.
