## Step 3: Deploy service B without propagation (broken)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-b-broken
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-b
  template:
    metadata:
      labels:
        app: service-b
        version: broken
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=Service B - NO HEADER PROPAGATION"
        - "-listen=:8080"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: service-b
spec:
  selector:
    app: service-b
  ports:
  - port: 8080
    targetPort: 8080
EOF
```{{exec}}

Traces stop at service-a because service-b-broken ignores trace headers.
