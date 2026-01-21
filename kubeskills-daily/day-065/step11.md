## Step 11: Test concurrent image pulls

```bash
# Deploy many pods pulling same image simultaneously
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: concurrent-pulls
spec:
  replicas: 20
  selector:
    matchLabels:
      app: concurrent
  template:
    metadata:
      labels:
        app: concurrent
    spec:
      containers:
      - name: app
        image: redis:7-alpine
        imagePullPolicy: Always
EOF

# Watch pull progress
kubectl get pods -l app=concurrent -w
```{{exec}}

Observe many pods pulling the same image in parallel.
