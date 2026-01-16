## Step 4: Watch controller logs (infinite reconciliation)

```bash
# Controller reconciles forever because status never updates
kubectl logs -f -l app=broken-controller --tail=20
```{{exec}}

You should see continuous reconciliation output.
