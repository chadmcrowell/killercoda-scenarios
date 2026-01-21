## Step 12: Test image pull timeout

```bash
# Simulate slow registry (concept)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: slow-pull
spec:
  containers:
  - name: app
    image: slow-registry.example.com/large-image:latest
    # Large images can timeout
EOF

sleep 15
kubectl describe pod slow-pull | grep -A 10 "Events:"
```{{exec}}

Watch for timeout-style pull errors from a slow registry.
