## Step 13: Check metrics-server refresh interval

```bash
kubectl get deployment metrics-server -n kube-system -o yaml | grep -A 5 args
```{{exec}}

Metrics typically refresh every ~60 seconds.
