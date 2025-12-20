## Step 2: Deploy BestEffort pod (no requests/limits)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: besteffort-pod
  labels:
    qos: besteffort
spec:
  containers:
  - name: app
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "100M"]
EOF
```{{exec}}

```bash
kubectl get pod besteffort-pod -o jsonpath='{.status.qosClass}'; echo ""
```{{exec}}

QoS class should be BestEffort.
