## Step 5: Test deprecated Deployment API

```bash
# Old deployment API (apps/v1beta1) removed in 1.16
cat <<EOF > /tmp/old-deployment.yaml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: old-deployment
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: old
    spec:
      containers:
      - name: app
        image: nginx
EOF

kubectl apply -f /tmp/old-deployment.yaml 2>&1 || echo "Old Deployment API not supported"

# Current API
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: new-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: new
  template:
    metadata:
      labels:
        app: new
    spec:
      containers:
      - name: app
        image: nginx
EOF
```{{exec}}

Old Deployment API removed in 1.16, apps/v1 is required.
