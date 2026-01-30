## Step 2: Simulate sidecar injection

```bash
# Create namespace with sidecar injection enabled
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: mesh-demo
  labels:
    istio-injection: enabled
EOF

# Deploy service with automatic sidecar
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-a
  namespace: mesh-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-a
  template:
    metadata:
      labels:
        app: service-a
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: service-a
  namespace: mesh-demo
spec:
  selector:
    app: service-a
  ports:
  - port: 80
EOF

kubectl wait --for=condition=Ready pod -n mesh-demo -l app=service-a --timeout=60s

# Check container count (with sidecar would be 2+)
kubectl get pod -n mesh-demo -l app=service-a -o jsonpath='{.items[0].spec.containers[*].name}'
echo ""
```{{exec}}

Create a mesh-enabled namespace and inspect containers.
