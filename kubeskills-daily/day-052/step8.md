## Step 8: Test etcd defragmentation

```bash
kubectl exec -n kube-system $ETCD_POD -- sh -c 'du -sh /var/lib/etcd'

kubectl exec -n kube-system $ETCD_POD -- sh -c \
  'ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  defrag'

kubectl exec -n kube-system $ETCD_POD -- sh -c 'du -sh /var/lib/etcd'
```{{exec}}

Defrag reclaims space after compaction.
