## Step 10: Test backup with labels

```bash
kubectl delete namespace backup-test
kubectl create namespace backup-test
kubectl label namespace backup-test backup=enabled

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: important-pod
  namespace: backup-test
  labels:
    tier: critical
spec:
  containers:
  - name: app
    image: nginx
---
apiVersion: v1
kind: Pod
metadata:
  name: unimportant-pod
  namespace: backup-test
  labels:
    tier: optional
spec:
  containers:
  - name: app
    image: nginx
EOF

velero backup create selective-backup \
  --selector tier=critical \
  --wait

velero backup describe selective-backup
```{{exec}}

Backs up only resources matching the label selector.
