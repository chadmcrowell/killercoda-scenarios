## Step 4: Test readiness probe (traffic routing)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: readiness-test
spec:
  replicas: 3
  selector:
    matchLabels:
      app: readiness
  template:
    metadata:
      labels:
        app: readiness
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Pod $HOSTNAME", "-listen=:8080"]
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 3
          failureThreshold: 2
---
apiVersion: v1
kind: Service
metadata:
  name: readiness-svc
spec:
  selector:
    app: readiness
  ports:
  - port: 80
    targetPort: 8080
EOF
```{{exec}}

```bash
kubectl get endpoints readiness-svc
```{{exec}}

Only ready pods appear as service endpoints.
