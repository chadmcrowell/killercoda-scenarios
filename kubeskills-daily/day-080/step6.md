## Step 6: Simulate controller API spam

```bash
# Deploy controller that lists frequently
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chatty-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      app: chatty
  template:
    metadata:
      labels:
        app: chatty
    spec:
      serviceAccountName: default
      containers:
      - name: controller
        image: bitnami/kubectl
        command:
        - sh
        - -c
        - |
          while true; do
            echo "Listing all pods..."
            kubectl get pods -A > /dev/null
            sleep 1  # Very frequent!
          done
EOF

kubectl wait --for=condition=Ready pod -l app=chatty --timeout=60s

# Watch logs
kubectl logs -f -l app=chatty --tail=20 &
LOG_PID=$!

sleep 20

kill $LOG_PID 2>/dev/null

echo "Chatty controllers:"
echo "- List/watch too frequently"
echo "- Don't use efficient watches"
echo "- Overwhelm API server"
echo "- Get throttled"
```{{exec}}

Controllers that list resources too frequently overwhelm the API server instead of using efficient watch-based caching.
