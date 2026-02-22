## Step 14: Test graceful termination

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: graceful-web
spec:
  serviceName: graceful-svc
  replicas: 1
  selector:
    matchLabels:
      app: graceful
  template:
    metadata:
      labels:
        app: graceful
    spec:
      terminationGracePeriodSeconds: 60
      containers:
      - name: app
        image: busybox
        command:
        - sh
        - -c
        - |
          trap 'echo "SIGTERM received, cleaning up..."; sleep 30; echo "Cleanup done"' TERM
          while true; do sleep 1; done
EOF

kubectl wait --for=condition=Ready pod -l app=graceful --timeout=60s
```{{exec}}

```bash
kubectl delete pod -l app=graceful &
DELETE_PID=$!

sleep 5
```{{exec}}

```bash
kubectl get pods -l app=graceful

sleep 35
```{{exec}}

```bash
kubectl get pods -l app=graceful 2>&1 || echo "Pod terminated gracefully"

wait $DELETE_PID 2>/dev/null
```{{exec}}

`terminationGracePeriodSeconds` gives the pod time to flush writes, close connections, and release locks before being killed. For stateful databases, this is critical to avoid data corruption.
