## Step 7: Test hostNetwork namespace

```bash
# Share host network namespace
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: hostnetwork-pod
spec:
  hostNetwork: true
  containers:
  - name: app
    image: nicolaka/netshoot
    command: ['sleep', '3600']
EOF

kubectl wait --for=condition=Ready pod hostnetwork-pod --timeout=60s

# Can access host network
kubectl exec hostnetwork-pod -- ip addr show | head -20

echo "With hostNetwork:"
echo "- Bypass NetworkPolicy"
echo "- Access localhost services"
echo "- Sniff network traffic"
echo "- Bind to privileged ports"
```{{exec}}

hostNetwork bypasses all NetworkPolicy enforcement and gives access to host-level network interfaces and services.
