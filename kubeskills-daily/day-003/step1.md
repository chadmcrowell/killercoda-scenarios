## Step 1: Deploy the memory hog

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: memory-hog
spec:
  containers:
  - name: stress
    image: polinux/stress
    resources:
      requests:
        memory: "64Mi"
      limits:
        memory: "128Mi"
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "256M", "--vm-hang", "1"]
EOF
```{{exec}}

The container requests 64Mi, is limited to 128Mi, but allocates 256Mi—destined for OOM.
