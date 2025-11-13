## Create a pod with “OnFailure” restart policy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: restart-onfailure
spec:
  restartPolicy: OnFailure
  containers:
  - name: fail-container
    image: busybox
    command: ['sh', '-c', 'echo "Running..."; sleep 5; exit 1']
EOF
```{{exec}}

**Watch the restart behavior:**

```bash
kubectl get pods restart-onfailure -w
```{{exec}}

This one restarts because exit code 1 = failure. Notice the restart count increasing.
Press `Ctrl+C` after ~30 seconds.