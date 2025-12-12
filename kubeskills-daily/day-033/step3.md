## Step 3: Deploy application v1

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-v1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
      version: v1
  template:
    metadata:
      labels:
        app: webapp
        version: v1
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=Version 1"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: webapp
spec:
  selector:
    app: webapp
  ports:
  - port: 80
    targetPort: 5678
APP
```

```bash
kubectl get pods -l app=webapp
```{{exec}}

Deploys v1 with a Service and waits for pods.
