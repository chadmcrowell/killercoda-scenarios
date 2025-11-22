## Step 3: Deploy a pod using this PVC

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: storage-app
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: broken-pvc
EOF
```{{exec}}

```bash
kubectl get pod storage-app
```{{exec}}

Pod stays `Pending` because the PVC never bound to a volume.
