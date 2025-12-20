## Step 6: Simulate memory pressure

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: memory-hog
spec:
  containers:
  - name: hog
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "800M"]
    resources:
      requests:
        memory: "500Mi"
      limits:
        memory: "1Gi"
EOF
```{{exec}}

```bash
kubectl get pods -w
kubectl get events --sort-by='.lastTimestamp' | grep -i evict
```{{exec}}

Watch which QoS class evicts first under memory pressure.
