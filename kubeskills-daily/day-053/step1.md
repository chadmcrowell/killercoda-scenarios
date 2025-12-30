## Step 1: Deploy distributed application

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: split-test-svc
spec:
  clusterIP: None
  selector:
    app: split-test
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: split-test
spec:
  serviceName: split-test-svc
  replicas: 3
  selector:
    matchLabels:
      app: split-test
  template:
    metadata:
      labels:
        app: split-test
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - containerPort: 80
EOF

kubectl wait --for=condition=Ready pods -l app=split-test --timeout=60s
```{{exec}}

Creates a headless service and StatefulSet with three pods.
