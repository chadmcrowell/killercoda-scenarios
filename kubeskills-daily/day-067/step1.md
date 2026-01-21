## Step 1: Test working init container

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-success
spec:
  initContainers:
  - name: init-1
    image: busybox
    command: ['sh', '-c', 'echo Init 1 complete; sleep 2']
  - name: init-2
    image: busybox
    command: ['sh', '-c', 'echo Init 2 complete; sleep 2']
  containers:
  - name: app
    image: nginx
EOF

# Watch init containers run sequentially
kubectl get pod init-success -w
```{{exec}}

Confirm init containers run in order before the app starts.
