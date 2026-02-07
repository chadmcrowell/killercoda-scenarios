## Step 10: Test kernel exploitation path

```bash
# Container that could exploit kernel
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: kernel-access-pod
spec:
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
    securityContext:
      privileged: true
  volumes:
  - name: kmsg
    hostPath:
      path: /dev/kmsg
EOF

echo "Kernel access vectors:"
echo "- Privileged container can load modules"
echo "- Can access /dev/kmsg"
echo "- Can exploit kernel vulnerabilities"
echo "- Container breakout via kernel exploit"
```{{exec}}

Privileged containers can load kernel modules and access kernel devices - a direct path to host compromise.
