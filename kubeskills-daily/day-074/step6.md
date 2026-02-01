## Step 6: Test etcd backup

```bash
# Get etcd pod
ETCD_POD=$(kubectl get pods -n kube-system -l component=etcd -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -n "$ETCD_POD" ]; then
  # Backup etcd
  kubectl exec -n kube-system $ETCD_POD -- sh -c \
    "ETCDCTL_API=3 etcdctl \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key \
    snapshot save /tmp/etcd-backup.db"

  # Verify backup
  kubectl exec -n kube-system $ETCD_POD -- sh -c \
    "ETCDCTL_API=3 etcdctl --write-out=table snapshot status /tmp/etcd-backup.db"
else
  echo "etcd pod not accessible"
  echo "In production: Use managed backup solution"
fi
```{{exec}}

etcd backup contains cluster state but not PV data.
