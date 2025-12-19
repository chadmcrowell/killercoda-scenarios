## Step 8: Test multiple init containers (sequential)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multi-init
spec:
  initContainers:
  - name: init-1
    image: busybox
    command: ['sh', '-c', 'echo "Init 1 running"; sleep 5; echo "Init 1 done"']
  - name: init-2
    image: busybox
    command: ['sh', '-c', 'echo "Init 2 running"; sleep 5; echo "Init 2 done"']
  - name: init-3
    image: busybox
    command: ['sh', '-c', 'echo "Init 3 running"; sleep 5; echo "Init 3 done"']
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl get pod multi-init -w
```{{exec}}

Watch Init:0/3 -> Init:3/3 -> Running to see ordered execution.
