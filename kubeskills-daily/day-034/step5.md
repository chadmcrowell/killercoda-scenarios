## Step 5: Deploy application in Team B

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-b
  namespace: team-b
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-b
      team: b
  template:
    metadata:
      labels:
        app: app-b
        team: b
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
---
apiVersion: v1
kind: Service
metadata:
  name: app-b-svc
  namespace: team-b
spec:
  selector:
    app: app-b
  ports:
  - port: 80
    targetPort: 80
APP
```{{exec}}

Deploys Team B's app with its own Service.
