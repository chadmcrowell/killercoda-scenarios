## Step 13: Check etcd consistency

```bash
kubectl exec -n kube-system $ETCD_POD -- sh -c \
  'ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  endpoint hash'
```{{exec}}

Hashes help detect divergence between members.
