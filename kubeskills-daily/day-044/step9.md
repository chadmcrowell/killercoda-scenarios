## Step 9: Check historical metrics with Metrics API

```bash
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes" | jq .
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods" | jq '.items[0]'
```{{exec}}

Query the metrics.k8s.io API directly for raw usage data.
