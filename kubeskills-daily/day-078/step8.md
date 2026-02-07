## Step 8: Test runAsUser: 0 (root)

```bash
# Running as root user
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: root-user-pod
spec:
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
    securityContext:
      runAsUser: 0  # Root!
EOF

kubectl wait --for=condition=Ready pod root-user-pod --timeout=60s

# Check user
kubectl exec root-user-pod -- id

echo "Running as root:"
echo "- Full permissions in container"
echo "- Can install packages"
echo "- Can modify system files"
echo "- Combined with other vectors = escape"
```{{exec}}

Running as root inside the container gives full permissions - combined with other misconfigurations it enables escape.
