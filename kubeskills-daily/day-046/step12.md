## Step 12: Test probe failure during rolling update

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rolling-update
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rolling
  template:
    metadata:
      labels:
        app: rolling
        version: v1
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=v1", "-listen=:8080"]
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /
            port: 8080
          periodSeconds: 2
          failureThreshold: 3
EOF
```{{exec}}

```bash
kubectl set image deployment/rolling-update app=hashicorp/http-echo:nonexistent
kubectl rollout status deployment/rolling-update --timeout=30s
```{{exec}}

Readiness failures halt the rollout before bad pods serve traffic.
