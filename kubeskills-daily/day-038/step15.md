## Step 15: Test headless service DNS

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: headless-svc
spec:
  clusterIP: None
  selector:
    app: headless
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: headless
spec:
  replicas: 3
  selector:
    matchLabels:
      app: headless
  template:
    metadata:
      labels:
        app: headless
    spec:
      containers:
      - name: app
        image: nginx
EOF
```{{exec}}

```bash
kubectl run resolver2 --rm -it --restart=Never --image=busybox -- nslookup headless-svc
```{{exec}}

Headless service returns individual pod IPs instead of a ClusterIP.
