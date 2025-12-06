## Step 5: Trigger memory pressure (carefully)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: memory-eater
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "500M", "--vm-hang", "10"]
    resources:
      requests:
        memory: "100Mi"
      limits:
        memory: "600Mi"
EOF
```{{exec}}

```bash
kubectl get pods -w
kubectl get events --sort-by='.lastTimestamp' | grep -i evict
```{{exec}}

Watch for evictions under memory pressure.
