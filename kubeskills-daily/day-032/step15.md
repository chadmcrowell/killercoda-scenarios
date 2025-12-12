## Step 15: Test health check failure

```bash
cat > unhealthy.yaml << 'UNHEALTHY'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: unhealthy-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: unhealthy
  template:
    metadata:
      labels:
        app: unhealthy
    spec:
      containers:
      - name: app
        image: nonexistent-image:latest
        imagePullPolicy: Always
UNHEALTHY

argocd app sync demo-app

# Check status
argocd app get demo-app
```{{exec}}

Health check should stay Progressing due to bad image.
