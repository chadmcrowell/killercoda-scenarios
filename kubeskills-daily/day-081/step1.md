## Step 1: Deploy target application

```bash
# Deploy resilient app to test
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chaos-target
spec:
  replicas: 3
  selector:
    matchLabels:
      app: chaos-target
  template:
    metadata:
      labels:
        app: chaos-target
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 3
---
apiVersion: v1
kind: Service
metadata:
  name: chaos-target
spec:
  selector:
    app: chaos-target
  ports:
  - port: 80
EOF

kubectl wait --for=condition=Ready pod -l app=chaos-target --timeout=60s
```{{exec}}

Deploy a multi-replica application with health checks as the target for chaos experiments.
