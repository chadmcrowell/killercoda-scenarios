## Step 11: Test ReclaimPolicy impact

```bash
# Create PV with Delete policy
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: delete-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete  # Deletes volume when PVC deleted
  hostPath:
    path: /tmp/delete-test
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: delete-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: ""
  volumeName: delete-pv
EOF

# Check binding
kubectl get pv delete-pv
kubectl get pvc delete-pvc

# Delete PVC (PV will be deleted too!)
kubectl delete pvc delete-pvc

sleep 5
kubectl get pv delete-pv 2>&1 || echo "PV deleted (Retain would preserve it)"
```{{exec}}

Watch how Delete reclaim policy removes the backing PV.
