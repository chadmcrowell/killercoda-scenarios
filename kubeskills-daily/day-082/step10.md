## Step 10: Simulate environment inconsistency

```bash
# Create "staging" version
kubectl create namespace staging 2>/dev/null

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: staging
spec:
  replicas: 2  # Different from prod (5)
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: nginx:1.20  # Older than prod (1.22)
        resources:
          requests:
            cpu: "50m"  # Half of prod
            memory: "64Mi"
EOF

echo "Staging environment deployed"
echo ""
echo "Production vs Staging:"
echo "Prod replicas: $(kubectl get deployment myapp -o jsonpath='{.spec.replicas}')"
echo "Staging replicas: $(kubectl get deployment myapp -n staging -o jsonpath='{.spec.replicas}')"
echo ""
echo "Prod image: $(kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[0].image}')"
echo "Staging image: $(kubectl get deployment myapp -n staging -o jsonpath='{.spec.template.spec.containers[0].image}')"
echo ""
echo "Drift: Environments no longer match!"
```{{exec}}

Environment inconsistency means staging no longer reflects production - bugs found in staging may not reproduce in prod.
