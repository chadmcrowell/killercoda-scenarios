## Step 11: Test RBAC isolation

```bash
# Try to list pods in team-b as team-a-admin
kubectl auth can-i list pods --namespace=team-b --as=system:serviceaccount:team-a:team-a-admin
```

```bash
TOKEN=$(kubectl create token team-a-admin -n team-a --duration=1h)
kubectl --token=$TOKEN get pods -n team-b 2>&1 | grep -i forbidden
```{{exec}}

RBAC should block cross-namespace pod listing.
