## Step 15: Test controller crash loop

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crash-loop-controller
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crash-loop
  template:
    metadata:
      labels:
        app: crash-loop
    spec:
      serviceAccountName: broken-controller
      containers:
      - name: controller
        image: bash:5
        command: ["/bin/bash"]
        args:
        - -c
        - |
          echo "Starting controller..."

          # Simulate panic/crash after processing
          TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
          API=https://kubernetes.default.svc

          curl -s -k -H "Authorization: Bearer $TOKEN" \
            $API/apis/example.com/v1/namespaces/default/apptasks

          echo "Simulating panic/crash!"
          exit 1
EOF

# Watch CrashLoopBackOff
watch kubectl get pod -l app=crash-loop
```{{exec}}

Crash loops are noisy and can hide reconciliation issues.
