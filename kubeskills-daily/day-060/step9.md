## Step 9: Deploy controller with resource leak

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: leaky-controller
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: leaky-controller
  template:
    metadata:
      labels:
        app: leaky-controller
    spec:
      serviceAccountName: broken-controller
      containers:
      - name: controller
        image: bash:5
        resources:
          limits:
            memory: "128Mi"
        command: ["/bin/bash"]
        args:
        - -c
        - |
          TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
          API=https://kubernetes.default.svc

          echo "Starting leaky controller..."

          # Simulate memory leak - store data without cleanup
          declare -a LEAKED_DATA

          while true; do
            # Get resources and store in memory (never cleared!)
            RESPONSE=$(curl -s -k -H "Authorization: Bearer $TOKEN" \
              $API/apis/example.com/v1/namespaces/default/apptasks)

            LEAKED_DATA+=("$RESPONSE")

            echo "Leaked data size: ${#LEAKED_DATA[@]} entries"

            sleep 5
          done
EOF

# Watch memory growth
watch -n 5 "kubectl top pod -l app=leaky-controller"

# Eventually OOMKilled!
kubectl get events --field-selector reason=OOMKilling
```{{exec}}

Leaky controllers can OOM and crash repeatedly.
