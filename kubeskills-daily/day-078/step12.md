## Step 12: Test seccomp bypass

```bash
# Container without seccomp
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: no-seccomp-pod
spec:
  securityContext:
    seccompProfile:
      type: Unconfined  # No syscall filtering!
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
EOF

kubectl wait --for=condition=Ready pod no-seccomp-pod --timeout=60s

echo "Without seccomp:"
echo "- No syscall restrictions"
echo "- Can use dangerous syscalls"
echo "- Can exploit kernel vulnerabilities"
echo "- Combined with other vectors = escape"
```{{exec}}

Without seccomp filtering, containers can make any syscall - increasing the kernel attack surface significantly.
