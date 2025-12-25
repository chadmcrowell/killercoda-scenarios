## Step 4: Deploy app with metrics endpoint

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: metrics-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: metrics-app
  template:
    metadata:
      labels:
        app: metrics-app
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - name: web
          containerPort: 80
        - name: metrics
          containerPort: 9113
---
apiVersion: v1
kind: Service
metadata:
  name: metrics-app-svc
  labels:
    app: metrics-app
spec:
  selector:
    app: metrics-app
  ports:
  - name: web
    port: 80
    targetPort: web
  - name: metrics
    port: 9113
    targetPort: metrics
EOF
```{{exec}}

Deploy an app with web and metrics ports exposed via service.
