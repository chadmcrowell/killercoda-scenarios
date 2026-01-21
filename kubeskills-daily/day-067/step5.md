## Step 5: Test init container with long timeout

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-timeout
spec:
  initContainers:
  - name: slow-init
    image: busybox
    command: ['sh', '-c', 'echo Starting long init; sleep 300']
  containers:
  - name: app
    image: nginx
EOF

# Pod stuck in Init for 5 minutes
kubectl get pod init-timeout
```{{exec}}

See how long-running init containers delay startup.
