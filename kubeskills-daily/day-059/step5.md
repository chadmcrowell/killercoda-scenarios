## Step 5: Check webhook status

```bash
kubectl describe validatingwebhookconfiguration blocking-webhook
```{{exec}}

Inspect configuration details and verify the timeout and failure policy.
