## Step 2: Deploy two backend services

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-v1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-v1
  template:
    metadata:
      labels:
        app: api-v1
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=API v1 Response"
        - "-listen=:8080"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: api-v1-svc
spec:
  selector:
    app: api-v1
  ports:
  - port: 80
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-v2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-v2
  template:
    metadata:
      labels:
        app: api-v2
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=API v2 Response"
        - "-listen=:8080"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: api-v2-svc
spec:
  selector:
    app: api-v2
  ports:
  - port: 80
    targetPort: 8080
EOF
```{{exec}}

```bash
kubectl get pods -l app=api-v1
kubectl get pods -l app=api-v2
```{{exec}}

Two echo services respond with distinct text for v1 and v2.
