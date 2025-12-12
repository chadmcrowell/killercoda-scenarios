## Step 16: Test sync with replace strategy

```bash
# Remove unhealthy app
rm unhealthy.yaml

cat > deployment.yaml << 'EOFDEP'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
  namespace: default
  annotations:
    argocd.argoproj.io/sync-options: Replace=true
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
      - name: nginx
        image: nginx:1.26
EOFDEP

argocd app sync demo-app
```{{exec}}

Replace=true forces delete/create instead of patching.
