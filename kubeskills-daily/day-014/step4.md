## Step 4: Fix by adding resource requests

```bash
cat <<EOF | kubectl apply -n quota-test -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: with-resources
spec:
  replicas: 3
  selector:
    matchLabels:
      app: with-resources
  template:
    metadata:
      labels:
        app: with-resources
    spec:
      containers:
      - name: app
        image: nginx
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
EOF
```{{exec}}

```bash
kubectl get pods -n quota-test -l app=with-resources
kubectl describe resourcequota strict-quota -n quota-test
```{{exec}}

Pods now run and quota usage reflects the requested/limited resources.
