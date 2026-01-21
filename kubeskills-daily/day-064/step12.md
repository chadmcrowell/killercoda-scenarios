## Step 12: Test WaitForFirstConsumer binding

```bash
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: wait-for-consumer
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer  # Delays binding
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: wait-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: wait-for-consumer
  hostPath:
    path: /tmp/wait
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wait-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: wait-for-consumer
  resources:
    requests:
      storage: 1Gi
EOF

# PVC stays Pending until pod uses it
kubectl get pvc wait-pvc

# Create pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: wait-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: storage
      mountPath: /data
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: wait-pvc
EOF

# Now PVC binds
sleep 5
kubectl get pvc wait-pvc
```{{exec}}

See how WaitForFirstConsumer delays binding until scheduling.
