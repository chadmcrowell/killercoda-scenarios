## Step 1: Check default node tolerations

```bash
kubectl run node-test --image=nginx
kubectl get pod node-test -o jsonpath='{.spec.tolerations}' | jq .
```{{exec}}

Defaults include 300s tolerations for not-ready and unreachable.
