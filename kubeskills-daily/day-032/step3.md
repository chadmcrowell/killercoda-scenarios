## Step 3: Create Git repo (simulated with local path)

```bash
mkdir -p /tmp/gitops-repo
cd /tmp/gitops-repo

cat > deployment.yaml << 'EOFDEP'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
  namespace: default
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
        image: nginx:1.25
        ports:
        - containerPort: 80
EOFDEP

cat > service.yaml << 'EOFSVC'
apiVersion: v1
kind: Service
metadata:
  name: demo-app
  namespace: default
spec:
  selector:
    app: demo
  ports:
  - port: 80
    targetPort: 80
EOFSVC
```{{exec}}

Local path simulates a Git repo for ArgoCD source.
