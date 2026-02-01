## Step 6: Check operator logs for RBAC errors

```bash
sleep 15
kubectl logs -n webapp-system -l app=webapp-operator --tail=20 | grep -i "forbidden\|error"
```{{exec}}

Operator logs show permission denied errors due to insufficient RBAC.
