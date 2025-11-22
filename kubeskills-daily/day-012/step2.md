## Step 1: Deploy a CPU-intensive app

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cpu-app
  template:
    metadata:
      labels:
        app: cpu-app
    spec:
      containers:
      - name: app
        image: vish/stress
        resources:
          requests:
            cpu: 100m
          limits:
            cpu: 200m
        args:
        - -cpus
        - "0"  # Idle initially
---
apiVersion: v1
kind: Service
metadata:
  name: cpu-app
spec:
  selector:
    app: cpu-app
  ports:
  - port: 80
    targetPort: 8080
EOF
```{{exec}}

Creates a minimal workload with CPU limits/requests and exposes it via a ClusterIP service.
