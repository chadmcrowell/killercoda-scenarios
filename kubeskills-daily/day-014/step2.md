## Step 2: Deploy without resource requests (fails silently)

```bash
cat <<EOF | kubectl apply -n quota-test -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: no-resources
spec:
  replicas: 3
  selector:
    matchLabels:
      app: no-resources
  template:
    metadata:
      labels:
        app: no-resources
    spec:
      containers:
      - name: app
        image: nginx
        # No resources defined!
EOF
```{{exec}}

```bash
kubectl get deployment -n quota-test no-resources
kubectl get pods -n quota-test
```{{exec}}

Deployment shows 0/3 ready and no pods were created, but errors are hidden.
