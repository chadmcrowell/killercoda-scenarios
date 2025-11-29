## Step 8: Use PVC in a pod

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pvc-user
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
      claimName: test-pvc
EOF
```{{exec}}

```bash
kubectl delete pvc test-pvc
kubectl get pvc test-pvc
```{{exec}}

PVC deletion is blocked while in use by the pod.
