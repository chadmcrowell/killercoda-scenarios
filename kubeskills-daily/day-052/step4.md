## Step 4: Create etcd snapshot (backup)

```bash
kubectl exec -n kube-system $ETCD_POD -- sh -c \
  'ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /tmp/etcd-backup.db'

kubectl cp -n kube-system $ETCD_POD:/tmp/etcd-backup.db ./etcd-backup.db
ls -lh etcd-backup.db
```{{exec}}

Save a local snapshot of etcd.
