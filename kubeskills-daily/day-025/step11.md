## Step 11: Manually compact etcd

```bash
ETCD_POD=$(kubectl get pods -n kube-system -l component=etcd -o jsonpath='{.items[0].metadata.name}')
REVISION=$(kubectl exec -n kube-system $ETCD_POD -- sh -c 'ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  endpoint status' | awk '{print $4}')

echo "Current revision: $REVISION"

kubectl exec -n kube-system $ETCD_POD -- sh -c "ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  compact $((REVISION - 1000))"
```{{exec}}

Compaction prunes older revisions to reclaim space.
