## Step 6: Simulate DestinationRule circuit breaker

```bash
# Simulate circuit breaker with deployment that fails
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flaky-service
  namespace: mesh-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: flaky
  template:
    metadata:
      labels:
        app: flaky
    spec:
      containers:
      - name: app
        image: busybox
        command:
        - sh
        - -c
        - |
          # 50% of requests fail
          while true; do
            nc -l -p 8080 -e sh -c 'if [ $((RANDOM % 2)) -eq 0 ]; then echo "HTTP/1.1 500 Error"; else echo "HTTP/1.1 200 OK"; fi; echo'
          done
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: flaky
  namespace: mesh-demo
spec:
  selector:
    app: flaky
  ports:
  - port: 80
    targetPort: 8080
EOF

kubectl wait --for=condition=Ready pod -n mesh-demo -l app=flaky --timeout=60s

# Test flaky service
echo "Testing flaky service (50% failure rate):"
for i in {1..10}; do
  kubectl run test-flaky-$i -n mesh-demo --rm -i --image=busybox --restart=Never -- \
    wget -O- --timeout=1 http://flaky.mesh-demo 2>&1 | grep -o "200\|500" || echo "Timeout"
done
```{{exec}}

Simulate a flaky backend and observe intermittent failures.
