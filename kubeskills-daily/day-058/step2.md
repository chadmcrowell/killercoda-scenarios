## Step 2: Deploy test backend services

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-v1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo
      version: v1
  template:
    metadata:
      labels:
        app: demo
        version: v1
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Version 1"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: app-v1-svc
spec:
  selector:
    app: demo
    version: v1
  ports:
  - port: 80
    targetPort: 5678
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-v2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo
      version: v2
  template:
    metadata:
      labels:
        app: demo
        version: v2
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Version 2"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: app-v2-svc
spec:
  selector:
    app: demo
    version: v2
  ports:
  - port: 80
    targetPort: 5678
EOF

kubectl wait --for=condition=Ready pods -l app=demo --timeout=60s
```{{exec}}

Deploy two versions of a demo service for routing tests.
