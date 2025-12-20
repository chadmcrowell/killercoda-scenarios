## Step 12: Test CPU throttling (Burstable)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cpu-throttled
spec:
  containers:
  - name: cpu-intensive
    image: polinux/stress
    command: ["stress"]
    args: ["--cpu", "2"]
    resources:
      requests:
        cpu: "100m"
      limits:
        cpu: "200m"
EOF
```{{exec}}

```bash
kubectl top pod cpu-throttled || true
```{{exec}}

CPU usage should cap around 200m even though the process asks for 2 cores.
