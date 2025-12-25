## Step 7: Deploy I/O-bound pod

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: io-bound
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--io", "4", "--timeout", "600s"]
    resources:
      requests:
        cpu: "100m"
        memory: "64Mi"
      limits:
        cpu: "500m"
        memory: "128Mi"
EOF
```{{exec}}

```bash
kubectl top pod io-bound
```{{exec}}

I/O work may not show high CPU; `kubectl top` cannot display I/O saturation.
