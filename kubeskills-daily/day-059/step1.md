## Step 1: Check existing webhooks

```bash
# List validating webhooks
kubectl get validatingwebhookconfigurations

# List mutating webhooks
kubectl get mutatingwebhookconfigurations
```{{exec}}

Inspect what admission webhooks already exist before changing anything.
