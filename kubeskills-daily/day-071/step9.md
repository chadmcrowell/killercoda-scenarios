## Step 9: Test operator crash

```bash
# Create operator that crashes
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crashy-operator
  namespace: webapp-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crashy-operator
  template:
    metadata:
      labels:
        app: crashy-operator
    spec:
      containers:
      - name: operator
        image: bash:5
        command:
        - bash
        - -c
        - |
          echo "Starting operator..."
          sleep 5
          echo "Crashing!"
          exit 1
EOF

# Watch crash loop (wait a bit then check)
sleep 15
kubectl get pods -n webapp-system -l app=crashy-operator
```{{exec}}

Operator enters CrashLoopBackOff, unable to reconcile resources.
