## **Create a pod with “Never” restart policy**

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: restart-never
spec:
  restartPolicy: Never
  containers:
  - name: fail-container
    image: busybox
    command: ['sh', '-c', 'echo "Running..."; sleep 5; exit 1']
EOF

```{{exec}}

**Check the status:**

```bash
kubectl get pods restart-never

```{{exec}}

Pod stays in “Error” state. No restart. Perfect for debugging!