## Step 7: Deploy working webhook server

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webhook-server
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webhook
  template:
    metadata:
      labels:
        app: webhook
    spec:
      containers:
      - name: webhook
        image: hashicorp/http-echo
        args:
        - -text={"response": {"allowed": true}}
        - -listen=:8443
        ports:
        - containerPort: 8443
---
apiVersion: v1
kind: Service
metadata:
  name: webhook-service
  namespace: default
spec:
  selector:
    app: webhook
  ports:
  - port: 443
    targetPort: 8443
EOF

kubectl wait --for=condition=Ready pod -l app=webhook --timeout=60s
```{{exec}}

Bring up a real endpoint so webhook calls can succeed.
