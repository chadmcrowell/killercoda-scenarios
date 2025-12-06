## Step 3: Test pod-to-pod connectivity

```bash
POD1_IP=$(kubectl get pod nettest-1 -o jsonpath='{.status.podIP}')
POD2_IP=$(kubectl get pod nettest-2 -o jsonpath='{.status.podIP}')

echo "Pod 1 IP: $POD1_IP"
echo "Pod 2 IP: $POD2_IP"

kubectl exec nettest-1 -- ping -c 3 $POD2_IP
```{{exec}}

Ping should succeed between pods.
