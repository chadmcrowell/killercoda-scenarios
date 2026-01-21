## Step 7: Test network policy with CNI support

```bash
# Check if CNI supports NetworkPolicy
kubectl api-resources | grep networkpolicies

# Create test namespace
kubectl create namespace netpol-test

# Deploy test pods
kubectl run web -n netpol-test --image=nginx --port=80
kubectl run client -n netpol-test --image=busybox --command -- sleep 3600

kubectl wait --for=condition=Ready pod -n netpol-test --all --timeout=60s

# Test connectivity before policy
WEB_IP=$(kubectl get pod web -n netpol-test -o jsonpath='{.status.podIP}')
kubectl exec -n netpol-test client -- wget -O- --timeout=2 http://$WEB_IP 2>&1 | grep -i "welcome\|connected" || echo "Connection failed"
```{{exec}}

Validate NetworkPolicy support and baseline connectivity.
