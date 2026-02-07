## Step 6: Simulate memory exhaustion

```bash
# Memory stress
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: memory-stress
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "256M", "--timeout", "60s"]
    resources:
      limits:
        memory: "512Mi"
EOF

kubectl wait --for=condition=Ready pod memory-stress --timeout=60s 2>/dev/null

sleep 70

kubectl get pod memory-stress
kubectl describe pod memory-stress | grep -A 5 "State:"

echo "Memory exhaustion test:"
echo "- Was pod OOMKilled?"
echo "- Did it restart automatically?"
echo "- Were other pods affected?"
```{{exec}}

Memory exhaustion tests verify OOMKill behavior, restart policies, and whether memory limits protect the node.
