## Step 3: Deploy application across nodes

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multi-node-app
spec:
  replicas: 6
  selector:
    matchLabels:
      app: multi-node
  template:
    metadata:
      labels:
        app: multi-node
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
EOF

kubectl get pods -l app=multi-node -o wide
```{{exec}}

Pods distribute across available nodes.
