## Step 3: Test list operation at scale

```bash
# Create many pods
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: many-pods
spec:
  replicas: 50
  selector:
    matchLabels:
      app: many
  template:
    metadata:
      labels:
        app: many
    spec:
      containers:
      - name: app
        image: nginx
        resources:
          requests:
            cpu: "10m"
            memory: "16Mi"
EOF

kubectl wait --for=condition=Available deployment many-pods --timeout=120s

# List all pods (expensive operation)
time kubectl get pods -A

echo ""
echo "List operations are expensive:"
echo "- Fetches all resources"
echo "- Large responses"
echo "- Counts toward rate limit"
```{{exec}}

List operations fetch all matching resources at once - they are expensive and count toward rate limits.
