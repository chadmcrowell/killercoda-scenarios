## Step 9: Simulate retry and timeout issues

```bash
# Service with long response time
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: slow-service
  namespace: mesh-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: slow
  template:
    metadata:
      labels:
        app: slow
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Slow response"]
        ports:
        - containerPort: 5678
        readinessProbe:
          httpGet:
            path: /
            port: 5678
          initialDelaySeconds: 30  # Slow to start
---
apiVersion: v1
kind: Service
metadata:
  name: slow
  namespace: mesh-demo
spec:
  selector:
    app: slow
  ports:
  - port: 80
    targetPort: 5678
EOF

# Without proper timeouts, requests hang
kubectl run test-timeout -n mesh-demo --rm -i --image=curlimages/curl --restart=Never -- \
  curl --max-time 5 http://slow.mesh-demo 2>&1 || echo "Request timed out"
```{{exec}}

See how slow services trigger timeouts.
