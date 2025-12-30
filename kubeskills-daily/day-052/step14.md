## Step 14: Monitor etcd write performance

```bash
watch -n 2 'kubectl exec -n kube-system $ETCD_POD -- sh -c \
  "curl -k --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  https://127.0.0.1:2379/metrics" | grep etcd_disk_backend_commit_duration_seconds_bucket | tail -5'
```{{exec}}

Track backend commit latency over time.
