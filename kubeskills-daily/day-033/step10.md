## Step 10: Check Istio proxy logs

```bash
POD=$(kubectl get pods -l app=webapp,version=v1 -o jsonpath='{.items[0].metadata.name}')
kubectl logs $POD -c istio-proxy | tail -20
```{{exec}}

Inspect sidecar logs for routing errors.
