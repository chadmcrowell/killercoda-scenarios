## Step 7: Test access mode mismatch

```bash
# Create PV with ReadOnlyMany
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: readonly-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadOnlyMany
  hostPath:
    path: /tmp/readonly
  persistentVolumeReclaimPolicy: Delete
EOF

# Request with ReadWriteOnce (won't match)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mismatch-pvc
spec:
  accessModes:
  - ReadWriteOnce  # Doesn't match PV
  resources:
    requests:
      storage: 1Gi
  storageClassName: ""  # Use manual binding
EOF

kubectl get pvc mismatch-pvc
```{{exec}}

Demonstrate how access mode mismatches prevent binding.
