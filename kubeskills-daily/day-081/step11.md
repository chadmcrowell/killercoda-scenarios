## Step 11: Simulate cascading failure

```bash
# Deploy interconnected services
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: app
        image: busybox
        command: ['sh', '-c', 'while true; do wget -O- backend:80 2>&1; sleep 1; done']
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: app
        image: busybox
        command: ['sh', '-c', 'while true; do wget -O- database:5432 2>&1; sleep 1; done']
---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
  - port: 80
---
apiVersion: v1
kind: Service
metadata:
  name: database
spec:
  selector:
    app: database  # No pods!
  ports:
  - port: 5432
EOF

sleep 30

echo "Cascading failure test:"
echo "- Database fails (no pods)"
echo "- Backend keeps retrying"
echo "- Frontend overwhelmed"
echo "- Entire system degraded"

kubectl logs -l app=backend --tail=5
```{{exec}}

Cascading failures show how a single service failure propagates through dependent services without circuit breakers.
