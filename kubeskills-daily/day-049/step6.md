## Step 6: Test backup with missing volume snapshots

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
  namespace: backup-test
spec:
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: pvc-pod
  namespace: backup-test
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'echo "PVC data" > /data/file.txt; sleep 3600']
    volumeMounts:
    - name: storage
      mountPath: /data
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: data-pvc
EOF

kubectl wait --for=condition=Ready pod -n backup-test pvc-pod --timeout=60s

velero backup create backup-with-pvc \
  --include-namespaces backup-test \
  --wait

velero backup describe backup-with-pvc --details
```{{exec}}

Backup runs without volume snapshots; PVC data is not captured.
