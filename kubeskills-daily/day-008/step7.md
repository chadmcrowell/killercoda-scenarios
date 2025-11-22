## Step 7: Create a consumer pod

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: consumer-app
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
      claimName: delayed-pvc
EOF
```{{exec}}

```bash
kubectl get pvc,pod -w
```{{exec}}

Once the pod schedules to a node, the PVC binds and the pod should move to `Running`. Stop the watch after you see the transitions.
