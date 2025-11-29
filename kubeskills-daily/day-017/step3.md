## Step 3: Check webhook status

```bash
kubectl get validatingwebhookconfiguration broken-webhook -o yaml
```{{exec}}

Inspect the failing webhook definition and note failurePolicy and timeoutSeconds.
