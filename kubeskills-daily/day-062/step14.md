## Step 14: Test service networking

```bash
# Create service
kubectl expose pod test-pod-1 --port=80 --name=test-svc

# Get service IP
SVC_IP=$(kubectl get svc test-svc -o jsonpath='{.spec.clusterIP}')
echo "Service IP: $SVC_IP"

# Test service access
kubectl exec test-pod-2 -- curl -s -m 3 http://$SVC_IP 2>&1 | head -5 || echo "Service networking issue"
```{{exec}}

Verify service VIP routing between pods.
