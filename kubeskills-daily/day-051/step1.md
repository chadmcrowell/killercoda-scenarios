## Step 1: Check API server metrics

```bash
kubectl get --raw /metrics | grep apiserver_request_total | head -20
kubectl get --raw /metrics | grep apiserver_current_inflight_requests
```{{exec}}

Inspect request counters and inflight limits.
