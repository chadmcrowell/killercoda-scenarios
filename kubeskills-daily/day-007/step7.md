## Step 7: Convert an init container into a sidecar (Kubernetes 1.28+)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-demo
spec:
  initContainers:
  - name: sidecar-logger
    image: busybox
    restartPolicy: Always
    command: ['sh', '-c', 'while true; do echo "$(date) - Sidecar running"; sleep 5; done']
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl get pods sidecar-demo -o jsonpath='{.status.containerStatuses[*].name}'
```{{exec}}

```bash
kubectl logs sidecar-demo -c sidecar-logger -f
```{{exec}}

Sidecar continues running beside the main container thanks to `restartPolicy: Always`.
