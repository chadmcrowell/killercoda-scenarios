## Step 8: Test noisy neighbor problem

```bash
# Team-a deploys resource-intensive workload
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: resource-hog
  namespace: team-a
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hog
  template:
    metadata:
      labels:
        app: hog
    spec:
      containers:
      - name: hog
        image: polinux/stress
        command: ["stress"]
        args: ["--cpu", "2", "--vm", "1", "--vm-bytes", "1G"]
        resources:
          requests:
            cpu: "1000m"
            memory: "1Gi"
          limits:
            cpu: "2000m"
            memory: "2Gi"
EOF

# Check if this impacts other tenants
sleep 30
kubectl top nodes
kubectl top pods -n team-a
kubectl top pods -n team-b 2>/dev/null || echo "May impact other tenants on same node"
```{{exec}}

Resource quotas don't prevent noisy neighbor issues on shared nodes.
