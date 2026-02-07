## Step 6: Test hostPID namespace

```bash
# Share host PID namespace
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: hostpid-pod
spec:
  hostPID: true
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
EOF

kubectl wait --for=condition=Ready pod hostpid-pod --timeout=60s

# Can see all host processes
kubectl exec hostpid-pod -- ps aux | head -20

echo "With hostPID:"
echo "- See all processes on node"
echo "- Can kill host processes"
echo "- Can read process memory"
echo "- Can access /proc of host processes"
```{{exec}}

Sharing the host PID namespace exposes all host processes - attackers can inspect, signal, or read memory of any process.
