## Step 2: Test failing init container

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-fail
spec:
  initContainers:
  - name: init-1
    image: busybox
    command: ['sh', '-c', 'echo Init 1 starting; exit 1']  # Fails!
  - name: init-2
    image: busybox
    command: ['sh', '-c', 'echo Init 2 (never runs)']
  containers:
  - name: app
    image: nginx
EOF

# Pod stuck in Init:0/2
sleep 10
kubectl get pod init-fail
kubectl describe pod init-fail | grep -A 10 "Events:"
```{{exec}}

See how a failed init blocks later init and app containers.
