## Step 2: Chaos experiment - Random pod kill

```bash
# Simulate pod failures
cat > /tmp/chaos-pod-kill.sh << 'EOF'
#!/bin/bash
echo "=== Chaos Experiment: Random Pod Kill ==="

while true; do
  # Get random pod
  POD=$(kubectl get pods -l app=chaos-target -o name | shuf -n 1)

  if [ -n "$POD" ]; then
    echo "$(date): Killing $POD"
    kubectl delete $POD --grace-period=0 --force
  fi

  # Wait before next kill
  sleep 30
done
EOF

chmod +x /tmp/chaos-pod-kill.sh

# Run in background
/tmp/chaos-pod-kill.sh &
CHAOS_PID=$!

# Monitor pod status
kubectl get pods -l app=chaos-target -w &
WATCH_PID=$!

sleep 120

# Stop chaos
kill $CHAOS_PID $WATCH_PID 2>/dev/null

echo ""
echo "Observations:"
kubectl get pods -l app=chaos-target
echo "Did replicas automatically recover?"
```{{exec}}

Kill random pods and observe whether the deployment automatically recovers to the desired replica count.
