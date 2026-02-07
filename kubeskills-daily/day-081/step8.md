## Step 8: Simulate service dependency failure

```bash
# Deploy dependent service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: database
spec:
  selector:
    app: nonexistent  # No pods match!
  ports:
  - port: 5432
EOF

# App trying to connect to failed service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dependent-app
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      while true; do
        echo "Trying to connect to database..."
        nc -zv database 5432 || echo "Connection failed"
        sleep 5
      done
EOF

kubectl wait --for=condition=Ready pod dependent-app --timeout=60s

sleep 20

kubectl logs dependent-app --tail=10

echo ""
echo "Dependency failure test:"
echo "- How does app handle missing service?"
echo "- Does it crash or retry?"
echo "- Are errors logged properly?"
echo "- Is there a circuit breaker?"
```{{exec}}

Service dependency failures reveal whether applications gracefully degrade or cascade failures when backends are unavailable.
