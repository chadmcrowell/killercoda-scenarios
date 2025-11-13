## Create a pod with "Always" restart policy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: restart-always
spec:
  restartPolicy: Always
  containers:
  - name: fail-container
    image: busybox
    command: ['sh', '-c', 'echo "Running..."; sleep 5; exit 0']
EOF
```{{exec}}

Watch the behavior
```bash
kubectl get pods restart-always -w
```{{exec}}

Notice: Even though the container exits successfully (code 0), K8s restarts it.

> ⚠️ Press Ctrl+C after ~30 seconds.