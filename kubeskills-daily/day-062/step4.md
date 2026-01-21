## Step 4: Simulate CNI config corruption

```bash
# Create pod that will fail due to CNI issues
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: network-test
  labels:
    test: cni
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: 10m
        memory: 16Mi
EOF

# Check status
sleep 5
kubectl get pod network-test
kubectl describe pod network-test | grep -A 10 "Events:"
```{{exec}}

Create a pod and inspect events for CNI-related failures.
