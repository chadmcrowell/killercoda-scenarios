## Step 13: Simulate sidecar crash

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sidecar-crash
  namespace: mesh-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crash-test
  template:
    metadata:
      labels:
        app: crash-test
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - containerPort: 80
      # Simulate crashing sidecar
      - name: proxy
        image: busybox
        command: ['sh', '-c', 'sleep 5; exit 1']
EOF

sleep 15

# Main container running but sidecar crashed
kubectl get pod -n mesh-demo -l app=crash-test
kubectl describe pod -n mesh-demo -l app=crash-test | grep -A 5 "State:"
```{{exec}}

Observe how a failed sidecar impacts pod health.
