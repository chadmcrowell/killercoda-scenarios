## Step 2: Deploy backend service

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=Hello from web-app"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 5678
EOF

kubectl wait --for=condition=Ready pod -l app=web --timeout=60s
```{{exec}}

Deploy the backend application and service that Ingress rules will route traffic to throughout this scenario.
