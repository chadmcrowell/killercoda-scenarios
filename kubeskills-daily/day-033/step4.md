## Step 4: Deploy application v2

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-v2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
      version: v2
  template:
    metadata:
      labels:
        app: webapp
        version: v2
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=Version 2 - NEW!"
        ports:
        - containerPort: 5678
APP
```{{exec}}

Adds v2 deployment for traffic splitting.
