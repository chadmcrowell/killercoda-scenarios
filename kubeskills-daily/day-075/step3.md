## Step 3: Simulate Prometheus scrape failure

```bash
# Create ServiceMonitor without matching service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: metrics-service
  labels:
    app: webapp
    metrics: "true"
spec:
  selector:
    app: webapp
  ports:
  - port: 9090
    targetPort: 9090
    name: metrics
EOF

echo "ServiceMonitor would fail to scrape:"
echo "- Port 9090 doesn't exist on pods"
echo "- Pods don't expose /metrics endpoint"
echo "- NetworkPolicy might block Prometheus"
```{{exec}}

Common Prometheus scrape failures demonstrated.
