## Step 10: Test certificate renewal failure

```bash
kubectl delete issuer selfsigned-issuer
sleep 30
kubectl describe certificate short-lived-cert | grep -A 10 Events
```{{exec}}

With the issuer removed, renewals should fail and events will show errors.
