## Step 3: Deploy CPU-bound pod

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cpu-bound
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--cpu", "2", "--timeout", "600s"]
    resources:
      requests:
        cpu: "100m"
        memory: "64Mi"
      limits:
        cpu: "200m"
        memory: "128Mi"
EOF
```{{exec}}

```bash
watch -n 2 "kubectl top pod cpu-bound"
```{{exec}}

CPU usage hits the 200m limit and gets throttled.
