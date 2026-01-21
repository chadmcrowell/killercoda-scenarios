## Step 3: Create StorageClass with invalid provisioner

```bash
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: broken-storage
provisioner: kubernetes.io/nonexistent
parameters:
  type: invalid
volumeBindingMode: Immediate
EOF
```{{exec}}

Define a StorageClass that points to a nonexistent provisioner.
