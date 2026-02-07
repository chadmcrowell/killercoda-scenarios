## Step 9: Test /proc filesystem access

```bash
# Read sensitive info from /proc
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: proc-reader
spec:
  hostPID: true
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
EOF

kubectl wait --for=condition=Ready pod proc-reader --timeout=60s

# Read environment variables of other processes
echo "Accessing /proc:"
kubectl exec proc-reader -- ls /proc | head -10

# In production, could read secrets from other process environments
echo "Can potentially read:"
echo "- Environment variables of host processes"
echo "- Command line arguments with credentials"
echo "- Memory maps"
```{{exec}}

With hostPID, the /proc filesystem exposes environment variables and command-line arguments of all host processes.
