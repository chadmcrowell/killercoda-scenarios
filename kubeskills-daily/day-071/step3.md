## Step 3: Test CRD validation failure

```bash
# Try to create CR that violates validation
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1
kind: WebApp
metadata:
  name: invalid-webapp
spec:
  replicas: 20  # Exceeds maximum of 10!
  image: nginx
EOF

# Validation blocks creation
sleep 5
kubectl get webapp invalid-webapp 2>&1 || echo "Validation failed as expected"
```{{exec}}

CRD validation blocks invalid resources at API server level.
