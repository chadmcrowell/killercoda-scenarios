## Step 3: Test pod without sidecar injection

```bash
# Create namespace WITHOUT injection
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: no-mesh
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-b
  namespace: no-mesh
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-b
  template:
    metadata:
      labels:
        app: service-b
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
  name: service-b
  namespace: no-mesh
spec:
  selector:
    app: service-b
  ports:
  - port: 80
EOF

kubectl wait --for=condition=Ready pod -n no-mesh -l app=service-b --timeout=60s

# Only has main container (no sidecar)
kubectl get pod -n no-mesh -l app=service-b -o jsonpath='{.items[0].spec.containers[*].name}'
echo ""
```{{exec}}

Compare a non-mesh namespace without injection.
