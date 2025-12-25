## Step 10: Test probe overhead

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-overhead
spec:
  replicas: 100
  selector:
    matchLabels:
      app: overhead
  template:
    metadata:
      labels:
        app: overhead
    spec:
      containers:
      - name: app
        image: nginx
        readinessProbe:
          httpGet:
            path: /
            port: 80
          periodSeconds: 1
        livenessProbe:
          httpGet:
            path: /
            port: 80
          periodSeconds: 1
EOF
```{{exec}}

```bash
kubectl top nodes
```{{exec}}

High-frequency probes across many pods consume node CPU.
