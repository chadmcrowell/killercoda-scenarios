## Step 2: Check current pod networking

```bash
# Deploy test pods
kubectl run test-pod-1 --image=nginx
kubectl run test-pod-2 --image=nginx

kubectl wait --for=condition=Ready pod test-pod-1 test-pod-2 --timeout=60s

# Get pod IPs
POD1_IP=$(kubectl get pod test-pod-1 -o jsonpath='{.status.podIP}')
POD2_IP=$(kubectl get pod test-pod-2 -o jsonpath='{.status.podIP}')

echo "Pod 1 IP: $POD1_IP"
echo "Pod 2 IP: $POD2_IP"

# Test connectivity
kubectl exec test-pod-1 -- ping -c 3 $POD2_IP
```{{exec}}

Verify pod IP assignment and basic pod-to-pod connectivity.
