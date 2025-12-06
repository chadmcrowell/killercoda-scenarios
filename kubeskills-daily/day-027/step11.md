## Step 11: Exhaust API quota deliberately

```bash
cat > /tmp/api-flood.sh << 'EOF'
#!/bin/bash
while true; do
  kubectl get pods > /dev/null 2>&1
  kubectl get services > /dev/null 2>&1
  kubectl get deployments > /dev/null 2>&1
done
EOF
chmod +x /tmp/api-flood.sh

/tmp/api-flood.sh &
FLOOD_PID=$!
sleep 30
kubectl get pods 2>&1
kill $FLOOD_PID 2>/dev/null
```{{exec}}

Sustained load should surface throttling or delays.
