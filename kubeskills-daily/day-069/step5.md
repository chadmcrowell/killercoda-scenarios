## Step 5: Simulate VirtualService routing

```bash
# Create two versions of a service
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-v1
  namespace: mesh-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
      version: v1
  template:
    metadata:
      labels:
        app: myapp
        version: v1
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Version 1"]
        ports:
        - containerPort: 5678
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-v2
  namespace: mesh-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
      version: v2
  template:
    metadata:
      labels:
        app: myapp
        version: v2
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Version 2"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: myapp
  namespace: mesh-demo
spec:
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 5678
EOF

kubectl wait --for=condition=Ready pod -n mesh-demo -l app=myapp --timeout=60s

# Without VirtualService, traffic load balances across all pods
for i in {1..10}; do
  kubectl run test-$i -n mesh-demo --rm -i --image=curlimages/curl --restart=Never -- \
    curl -s http://myapp.mesh-demo | grep Version
done
```{{exec}}

Observe default load balancing across versions.
