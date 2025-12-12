## Step 4: Deploy application in Team A

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-a
  namespace: team-a
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app-a
      team: a
  template:
    metadata:
      labels:
        app: app-a
        team: a
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
  name: app-a-svc
  namespace: team-a
spec:
  selector:
    app: app-a
  ports:
  - port: 80
    targetPort: 80
APP
```{{exec}}

Deploys Team A's app with resource requests/limits.
