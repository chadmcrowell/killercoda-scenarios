## Step 4: Simulate network packet loss

```bash
cat > /tmp/chaos-packet-loss.yaml << 'EOF'
apiVersion: chaos-mesh.org/v1alpha1
kind: NetworkChaos
metadata:
  name: packet-loss
spec:
  action: loss
  mode: all
  selector:
    labelSelectors:
      app: chaos-target
  loss:
    loss: "25"  # 25% packet loss
    correlation: "25"
  duration: "1m"
EOF

cat /tmp/chaos-packet-loss.yaml

echo ""
echo "Packet loss chaos:"
echo "- 25% of packets dropped"
echo "- Tests TCP retry behavior"
echo "- Reveals connection pool issues"
echo "- Exposes timeout problems"
```{{exec}}

Packet loss exposes connection pool exhaustion, retry storms, and applications that assume reliable networking.
