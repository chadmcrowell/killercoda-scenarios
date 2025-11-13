## Step 6: Multiple init containers run sequentially

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multi-init
spec:
  initContainers:
  - name: init-1
    image: busybox
    command: ['sh', '-c', 'echo "Init 1 starting"; sleep 5; echo "Init 1 done"']
  - name: init-2
    image: busybox
    command: ['sh', '-c', 'echo "Init 2 starting"; sleep 5; echo "Init 2 done"']
  - name: init-3
    image: busybox
    command: ['sh', '-c', 'echo "Init 3 starting"; sleep 5; echo "Init 3 done"']
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl get pods multi-init -w
```{{exec}}

Ordinals move from `Init:0/3` to `Init:3/3`, proving that init containers are strictly sequential.

```bash
kubectl logs multi-init -c init-1
kubectl logs multi-init -c init-2
kubectl logs multi-init -c init-3
```{{exec}}

Review each init container log independently.
