## Step 5: Deploy pod with PVC

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pvc-pod
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
      claimName: broken-pvc
EOF

# Check pod status (stuck ContainerCreating)
sleep 10
kubectl get pod pvc-pod
kubectl describe pod pvc-pod | grep -A 10 "Events:"
```{{exec}}

Observe the pod waiting on the unbound PVC.
