## Step 15: Test default backend

```bash
# Deploy default backend
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: default-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: default
  template:
    metadata:
      labels:
        app: default
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=404 Not Found"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: default-backend-svc
spec:
  selector:
    app: default
  ports:
  - port: 80
    targetPort: 5678
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: with-default
spec:
  ingressClassName: nginx
  defaultBackend:
    service:
      name: default-backend-svc
      port:
        number: 80
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /v1
        pathType: Prefix
        backend:
          service:
            name: app-v1-svc
            port:
              number: 80
EOF

# Test unmatched path (goes to default backend)
curl -H "Host: app.example.com" http://$INGRESS_IP/unmatched
```{{exec}}

Default backends catch unmatched routes.
