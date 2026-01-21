## Step 4: Try to exceed CPU quota

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cpu-hog
  namespace: quota-test
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "1000m"  # Would exceed remaining 500m
        memory: "256Mi"
EOF

# Pod rejected
sleep 5
kubectl get pod cpu-hog -n quota-test 2>&1 || echo "Pod creation failed"
kubectl get events -n quota-test | grep cpu-hog
```{{exec}}

See a pod rejected for exceeding CPU requests.
