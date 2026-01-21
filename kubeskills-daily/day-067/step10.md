## Step 10: Test restartPolicy with init containers

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-never-restart
spec:
  restartPolicy: Never  # Don't restart on failure
  initContainers:
  - name: failing-init
    image: busybox
    command: ['sh', '-c', 'exit 1']
  containers:
  - name: app
    image: nginx
EOF

# Pod fails and doesn't restart
sleep 10
kubectl get pod init-never-restart
kubectl describe pod init-never-restart | grep -A 5 "State:"
```{{exec}}

See how restartPolicy affects failed init behavior.
