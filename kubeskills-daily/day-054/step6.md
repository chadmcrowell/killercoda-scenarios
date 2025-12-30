## Step 6: Simulate renewal failure

```bash
kubectl delete issuer test-issuer
sleep 60
kubectl describe certificate short-lived-cert | grep -A 10 "Events:"
```{{exec}}

Removing the issuer forces renewal failures to appear in events.
