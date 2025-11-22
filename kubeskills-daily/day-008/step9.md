## Step 9: Access mode conflicts

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: shared-pvc
spec:
  accessModes:
    - ReadWriteMany  # Not supported by all provisioners!
  storageClassName: super-fast-nvme
  resources:
    requests:
      storage: 1Gi
EOF
```{{exec}}

```bash
kubectl describe pvc shared-pvc | grep -A 5 Events
```{{exec}}

Many dynamic provisioners don't support `ReadWriteMany`, so you'll likely see provisioning failures or a PVC stuck in `Pending`.
