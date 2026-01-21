## Step 8: Test storage with wrong volume mode

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: block-pvc
spec:
  accessModes:
  - ReadWriteOnce
  volumeMode: Block  # Raw block device
  resources:
    requests:
      storage: 1Gi
EOF

# Most storage classes expect Filesystem, not Block
kubectl describe pvc block-pvc
```{{exec}}

Check how volumeMode affects provisioning.
