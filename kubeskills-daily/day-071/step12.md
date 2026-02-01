## Step 12: Test operator watch errors

```bash
# Simulate operator watching wrong resource
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wrong-watch-operator
  namespace: webapp-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wrong-watch
  template:
    metadata:
      labels:
        app: wrong-watch
    spec:
      serviceAccountName: webapp-operator
      containers:
      - name: operator
        image: bash:5
        command:
        - bash
        - -c
        - |
          TOKEN=\$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
          API=https://kubernetes.default.svc

          # Watch non-existent resource
          echo "Watching fake resource..."
          while true; do
            curl -s -k -H "Authorization: Bearer \$TOKEN" \
              \$API/apis/fake.io/v1/fakeresources?watch=true 2>&1 | \
              grep -o "404\|Not Found" || true
            sleep 5
          done
EOF

kubectl wait --for=condition=Ready pod -n webapp-system -l app=wrong-watch --timeout=60s
sleep 10
kubectl logs -n webapp-system -l app=wrong-watch --tail=10
```{{exec}}

Operator watching non-existent resource gets 404 errors.
