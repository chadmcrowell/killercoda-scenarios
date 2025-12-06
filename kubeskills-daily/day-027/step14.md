## Step 14: Monitor inflight requests

```bash
kubectl get --raw /metrics | grep apiserver_current_inflight_requests
```{{exec}}

Shows executing requests and max allowed per concurrency shares.
