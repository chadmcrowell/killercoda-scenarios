## Step 5: Deploy memory-bound pod

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: memory-bound
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "500M", "--vm-hang", "1"]
    resources:
      requests:
        cpu: "100m"
        memory: "256Mi"
      limits:
        cpu: "500m"
        memory: "512Mi"
EOF
```{{exec}}

```bash
watch -n 2 "kubectl top pod memory-bound"
```{{exec}}

Watch memory usage climb near its limit.
