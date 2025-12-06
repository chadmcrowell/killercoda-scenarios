## Step 5: Check API server metrics

```bash
kubectl get --raw /metrics | grep apiserver_request | head -20
```{{exec}}

Key metrics include request totals, durations, and inflight counts.
