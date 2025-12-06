## Step 13: Backup etcd

```bash
ETCD_POD=$(kubectl get pods -n kube-system -l component=etcd -o jsonpath='{.items[0].metadata.name}')

kubectl exec -n kube-system $ETCD_POD -- sh -c 'ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /tmp/etcd-backup.db'

kubectl cp -n kube-system $ETCD_POD:/tmp/etcd-backup.db ./etcd-backup.db
ls -lh ./etcd-backup.db
```{{exec}}

Snapshot provides a restore point.
