## Step 2: Deploy pods within quota

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: within-quota
  namespace: quota-test
spec:
  replicas: 3
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
      - name: app
        image: nginx
        resources:
          requests:
            cpu: "500m"
            memory: "512Mi"
          limits:
            cpu: "1000m"
            memory: "1Gi"
EOF

kubectl wait --for=condition=Ready pod -n quota-test -l app=test --timeout=60s

# Check quota usage
kubectl describe resourcequota basic-quota -n quota-test
```{{exec}}

Create a deployment that fits within quota limits.
