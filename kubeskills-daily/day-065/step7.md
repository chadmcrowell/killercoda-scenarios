## Step 7: Test Docker Hub rate limiting

```bash
# Check current pull count (if accessible)
echo "Docker Hub rate limits:"
echo "- Anonymous: 100 pulls per 6 hours"
echo "- Authenticated: 200 pulls per 6 hours"
echo "- Rate limit is per IP address"

# Simulate hitting rate limit
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rate-limit-test
spec:
  replicas: 10
  selector:
    matchLabels:
      app: rate-test
  template:
    metadata:
      labels:
        app: rate-test
    spec:
      containers:
      - name: app
        image: nginx:latest  # Public image
        command: ['sleep', '3600']
EOF

kubectl wait --for=condition=Ready pod -l app=rate-test --timeout=120s

# Delete and recreate to trigger new pulls
kubectl delete deployment rate-limit-test
sleep 5
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rate-limit-test
spec:
  replicas: 10
  selector:
    matchLabels:
      app: rate-test
  template:
    metadata:
      labels:
        app: rate-test
    spec:
      containers:
      - name: app
        image: nginx:alpine  # Different image
EOF

# Check for rate limit errors
sleep 30
kubectl get events --sort-by='.lastTimestamp' | grep -i "rate\|limit\|throttle" | tail -5
```{{exec}}

Simulate rate limiting by forcing repeated pulls.
