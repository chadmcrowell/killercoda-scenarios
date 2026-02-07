## Step 5: Simulate CPU stress

```bash
# CPU stress chaos
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cpu-stress
  labels:
    app: chaos-target
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--cpu", "2", "--timeout", "120s"]
    resources:
      limits:
        cpu: "2"
        memory: "1Gi"
EOF

kubectl wait --for=condition=Ready pod cpu-stress --timeout=60s

# Monitor impact
kubectl top pods -l app=chaos-target &
TOP_PID=$!

sleep 30

kill $TOP_PID 2>/dev/null

kubectl delete pod cpu-stress

echo "CPU stress test:"
echo "- How did other pods perform?"
echo "- Did node become unresponsive?"
echo "- Did pods get evicted?"
```{{exec}}

CPU stress tests reveal how resource contention affects neighboring pods and whether limits are properly configured.
