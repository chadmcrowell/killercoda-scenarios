## Step 9: Simulate real-world traffic pattern

```bash
# Create a load generator deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: traffic-sim
spec:
  replicas: 0
  selector:
    matchLabels:
      app: traffic-sim
  template:
    metadata:
      labels:
        app: traffic-sim
    spec:
      containers:
      - name: load
        image: busybox
        command: ['sh', '-c', 'while true; do wget -q -O- http://cpu-app; sleep 0.1; done']
EOF
```{{exec}}

```bash
# Spike traffic
kubectl scale deployment traffic-sim --replicas=10
sleep 30
kubectl get hpa cpu-app-hpa

# Reduce traffic
kubectl scale deployment traffic-sim --replicas=2
sleep 60
kubectl get hpa cpu-app-hpa

# Another spike
kubectl scale deployment traffic-sim --replicas=10
```{{exec}}

Watch for oscillation as traffic bounces; the tuned behavior should reduce thrashing.
