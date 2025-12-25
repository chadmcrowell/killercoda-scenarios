## Step 5: Check ephemeral containers in pod

```bash
kubectl get pod minimal-app -o jsonpath='{.spec.ephemeralContainers}' | jq .
```{{exec}}

See which ephemeral containers have been attached.
