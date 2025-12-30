## Step 5: Test cert-manager renewal

```bash
kubectl get events --field-selector involvedObject.name=short-lived-cert --sort-by='.lastTimestamp'

kubectl get certificate short-lived-cert -o jsonpath='{.status.renewalTime}'; echo ""
```{{exec}}

Check renewal events and renewalTime for the short-lived cert.
