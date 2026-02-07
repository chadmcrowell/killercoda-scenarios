## Step 2: Test privileged container

```bash
# Privileged container (dangerous!)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: privileged-pod
spec:
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
    securityContext:
      privileged: true  # Full host access!
EOF

kubectl wait --for=condition=Ready pod privileged-pod --timeout=60s

# Can see host devices
kubectl exec privileged-pod -- ls -la /dev | head -20

echo "Privileged container can:"
echo "- Access all host devices"
echo "- Load kernel modules"
echo "- Manipulate host filesystem"
echo "- Compromise entire node"
```{{exec}}

A privileged container has unrestricted access to host devices and the kernel - equivalent to root on the node.
