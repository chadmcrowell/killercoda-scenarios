## Step 14: Check webhook latency

```bash
# Time pod creation with webhook
time kubectl run latency-test --image=nginx --restart=Never

# Check webhook metrics (if available)
kubectl get --raw /metrics | grep webhook
```{{exec}}

Measure how slow webhooks add latency to all API operations.
