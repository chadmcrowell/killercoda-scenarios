## Step 2: Deploy pods to fill capacity

```bash
# Create namespace
kubectl create namespace capacity-test

# Deploy many pods requesting resources
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: resource-hog
  namespace: capacity-test
spec:
  replicas: 20
  selector:
    matchLabels:
      app: hog
  template:
    metadata:
      labels:
        app: hog
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
```

**Watch scheduling:**
```bash
kubectl get pods -n capacity-test -w
```

Create pressure by scheduling many resource-hungry pods.
