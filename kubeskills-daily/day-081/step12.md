## Step 12: Test blast radius

```bash
# Inject failure in one namespace
kubectl create namespace chaos-zone

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chaos-app
  namespace: chaos-zone
spec:
  replicas: 3
  selector:
    matchLabels:
      app: chaos
  template:
    metadata:
      labels:
        app: chaos
    spec:
      containers:
      - name: app
        image: nginx
EOF

kubectl wait --for=condition=Ready pod -n chaos-zone -l app=chaos --timeout=60s

# Kill all pods in chaos-zone
kubectl delete pods -n chaos-zone --all

sleep 10

# Check if other namespaces affected
echo "Blast radius test:"
echo "Chaos zone:"
kubectl get pods -n chaos-zone
echo ""
echo "Default namespace:"
kubectl get pods -l app=chaos-target

echo ""
echo "Was failure isolated to chaos-zone?"
```{{exec}}

Blast radius testing confirms that failures in one namespace are isolated and don't affect workloads in other namespaces.
