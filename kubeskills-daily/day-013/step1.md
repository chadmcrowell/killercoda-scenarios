## Step 1: Deploy a 2-replica application

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: critical-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: critical-app
  template:
    metadata:
      labels:
        app: critical-app
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - containerPort: 80
EOF
```{{exec}}

```bash
kubectl get pods -l app=critical-app -o wide
```{{exec}}

Note which nodes the replicas land on—you'll target one for drain.
