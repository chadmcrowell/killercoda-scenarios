## Step 15: Monitor etcd metrics via API server

```bash
kubectl get --raw /metrics | grep etcd | head -20
```{{exec}}

Key metrics include request duration and disk fsync timings.
