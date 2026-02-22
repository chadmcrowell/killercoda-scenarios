## Step 13: Test PVC expansion

```bash
kubectl get storageclass -o jsonpath='{.items[*].allowVolumeExpansion}'
echo ""
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-web-0
spec:
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: 2Gi
EOF

sleep 10

kubectl get pvc data-web-0

echo ""
echo "PVC expansion:"
echo "- Requires storage class with allowVolumeExpansion: true"
echo "- Some volume types require pod restart"
echo "- Can fail if storage backend doesn't support it"
```{{exec}}

PVC expansion requires `allowVolumeExpansion: true` on the StorageClass. If the backend doesn't support it, the resize request will stay pending — the pod continues running on the original volume size.
