## Step 6: Create a BestEffort pod

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: memory-besteffort
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "100M", "--vm-hang", "1"]
EOF
```{{exec}}

```bash
kubectl get pod memory-besteffort -o jsonpath='{.status.qosClass}'
```{{exec}}

Output: `BestEffort`—first to be evicted during node pressure.
