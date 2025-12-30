## Step 12: Snapshot restore (conceptual/dry run)

```bash
echo "Snapshot restore procedure (do NOT run in production):"
cat << 'EOF'
# 1. Stop API server
systemctl stop kube-apiserver

# 2. Restore snapshot
ETCDCTL_API=3 etcdctl snapshot restore etcd-backup.db \
  --data-dir=/var/lib/etcd-restored \
  --name=etcd-0 \
  --initial-cluster=etcd-0=https://127.0.0.1:2380 \
  --initial-advertise-peer-urls=https://127.0.0.1:2380

# 3. Move restored data into place
mv /var/lib/etcd /var/lib/etcd-old
mv /var/lib/etcd-restored /var/lib/etcd

# 4. Start etcd
systemctl start etcd

# 5. Start API server
systemctl start kube-apiserver

# 6. Verify
kubectl get nodes
EOF
```{{exec}}

Restoring from snapshot requires downtime and careful steps.
