## Step 5: Create a Guaranteed QoS pod

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: memory-guaranteed
spec:
  containers:
  - name: stress
    image: polinux/stress
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "100m"
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "100M", "--vm-hang", "1"]
EOF
```{{exec}}

**Check the QoS class:**

```bash
kubectl get pod memory-guaranteed -o jsonpath='{.status.qosClass}'
```{{exec}}

Output: `Guaranteed`. Requests = limits for every container.
