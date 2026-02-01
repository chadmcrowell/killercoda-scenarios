## Step 2: Create custom resource

```bash
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1
kind: WebApp
metadata:
  name: my-webapp
spec:
  replicas: 3
  image: nginx:latest
EOF

# Check CR
kubectl get webapps
kubectl describe webapp my-webapp
```{{exec}}

Custom resource created successfully with valid spec.
