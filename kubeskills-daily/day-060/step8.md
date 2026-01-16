## Step 8: Deploy controller with immediate retry (no backoff)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: retry-bomb-controller
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: retry-bomb
  template:
    metadata:
      labels:
        app: retry-bomb
    spec:
      serviceAccountName: broken-controller
      containers:
      - name: controller
        image: bash:5
        command: ["/bin/bash"]
        args:
        - -c
        - |
          TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
          API=https://kubernetes.default.svc

          echo "Starting retry-bomb controller..."

          while true; do
            # Simulate failing operation with IMMEDIATE retry
            # No backoff = API server overload!

            curl -s -k -H "Authorization: Bearer $TOKEN" \
              $API/apis/example.com/v1/namespaces/default/apptasks/nonexistent 2>&1

            echo "Failed! Retrying immediately..."
            # BUG: No sleep/backoff before retry!
          done
EOF

# Check API server load
kubectl top pod -l app=retry-bomb

# Check API server metrics
kubectl get --raw /metrics | grep apiserver_request_total | tail -20
```{{exec}}

Retries without backoff can overwhelm the API server.
