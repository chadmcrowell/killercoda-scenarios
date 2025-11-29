## Step 2: Deploy test pods

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: default-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: default-app
  template:
    metadata:
      labels:
        app: default-app
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 100m
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: stateful-app
spec:
  serviceName: stateful
  replicas: 2
  selector:
    matchLabels:
      app: stateful
  template:
    metadata:
      labels:
        app: stateful
    spec:
      containers:
      - name: nginx
        image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: stateful
spec:
  clusterIP: None
  selector:
    app: stateful
  ports:
  - port: 80
EOF
```{{exec}}

```bash
kubectl get pods -o wide
```{{exec}}

Confirm placement of Deployment and StatefulSet pods.
