## Step 3: Simulate network latency

```bash
# Network delay chaos (conceptual)
cat > /tmp/chaos-network-latency.yaml << 'EOF'
# Chaos Mesh NetworkChaos example
apiVersion: chaos-mesh.org/v1alpha1
kind: NetworkChaos
metadata:
  name: network-delay
spec:
  action: delay
  mode: one
  selector:
    labelSelectors:
      app: chaos-target
  delay:
    latency: "500ms"
    correlation: "50"
    jitter: "100ms"
  duration: "2m"
EOF

cat /tmp/chaos-network-latency.yaml

echo ""
echo "Network latency chaos:"
echo "- Adds 500ms delay to network calls"
echo "- Tests timeout handling"
echo "- Reveals slow query issues"
echo "- Exposes retry logic problems"
```{{exec}}

Network latency injection tests how applications handle slow responses and whether timeouts are configured correctly.
