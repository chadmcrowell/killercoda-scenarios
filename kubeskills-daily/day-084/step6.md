## Step 6: Test path type confusion

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=API Response"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 5678
EOF

kubectl wait --for=condition=Ready pod -l app=api --timeout=60s
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: path-types-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /api
        pathType: Exact
        backend:
          service:
            name: api-service
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

echo "Path type differences:"
echo "Exact: /api matches, /api/ doesn't match"
echo "Prefix: /api matches /api, /api/v1, /api/users"
echo "ImplementationSpecific: Controller-dependent"
```{{exec}}

`Exact` matches only the literal path — `/api` matches but `/api/` or `/api/users` does not. `Prefix` matches the path and all sub-paths. Confusing the two is a common source of silent routing failures.
