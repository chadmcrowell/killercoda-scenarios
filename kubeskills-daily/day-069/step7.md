## Step 7: Simulate sidecar resource issues

```bash
# Sidecar proxy consuming too many resources
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: resource-starved
  namespace: mesh-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: starved
  template:
    metadata:
      labels:
        app: starved
    spec:
      containers:
      - name: app
        image: nginx
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "200m"
            memory: "256Mi"
      # Simulate sidecar
      - name: sidecar-proxy
        image: envoyproxy/envoy:v1.28-latest
        command: ['sleep', '3600']
        resources:
          requests:
            cpu: "500m"  # Heavy sidecar!
            memory: "512Mi"
          limits:
            cpu: "1000m"
            memory: "1Gi"
EOF

# Check resource usage
sleep 20
kubectl top pod -n mesh-demo -l app=starved 2>/dev/null || echo "Metrics not available"
```{{exec}}

Observe sidecar resource overhead.
