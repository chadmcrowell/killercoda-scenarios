## Step 5: Simulate readiness failure

```bash
POD=$(kubectl get pods -l app=readiness -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD -- killall -9 http-echo || true

kubectl get endpoints readiness-svc -w
```{{exec}}

The killed pod leaves endpoints until readiness recovers.
