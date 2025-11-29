## Step 1: Create a restricted ServiceAccount

```bash
kubectl create namespace rbac-test
kubectl create serviceaccount restricted-sa -n rbac-test
```{{exec}}

Minimal ServiceAccount exists but has no permissions beyond token review helpers.
