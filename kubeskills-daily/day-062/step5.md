## Step 5: Test IP address exhaustion

```bash
# Check pod CIDR range
kubectl get nodes -o jsonpath='{.items[0].spec.podCIDR}'
echo ""

# Calculate available IPs (for demonstration)
echo "Pod CIDR typically provides 254 IPs per /24 network"
echo "Creating many pods to exhaust IP pool..."

# Create deployment with many replicas
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ip-exhaustion
spec:
  replicas: 50
  selector:
    matchLabels:
      app: exhaust
  template:
    metadata:
      labels:
        app: exhaust
    spec:
      containers:
      - name: app
        image: nginx
        resources:
          requests:
            cpu: 10m
            memory: 16Mi
EOF

# Watch pod creation
kubectl get pods -l app=exhaust -w
```{{exec}}

Stress the pod CIDR by creating many pods.
