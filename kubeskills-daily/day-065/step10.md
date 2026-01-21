## Step 10: Test image digest pinning

```bash
# Use image digest for immutability
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: digest-pin
spec:
  containers:
  - name: app
    image: nginx@sha256:2d4c0b9f9d8f8b7a8c8e8f8a8b8c8d8e8f8a8b8c8d8e8f8a8b8c8d8e8f8a8b8c
    # Digest ensures exact image version
EOF

# Check if image exists with that digest
sleep 10
kubectl describe pod digest-pin | grep -A 5 "Events:"
```{{exec}}

See what happens when digest pinning uses an invalid digest.
