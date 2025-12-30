## Step 10: Test etcd metrics

```bash
kubectl exec -n kube-system $ETCD_POD -- sh -c \
  'curl -k --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  https://127.0.0.1:2379/metrics' | grep -E "etcd_server|etcd_disk" | head -20
```{{exec}}

Grab server/disk metrics from etcd.
