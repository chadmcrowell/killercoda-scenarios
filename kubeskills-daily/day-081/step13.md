## Step 13: Validate steady state

```bash
# Define steady state
cat > /tmp/steady-state-check.sh << 'EOF'
#!/bin/bash
echo "=== Steady State Validation ==="

# Check 1: All replicas ready
READY=$(kubectl get deployment chaos-target -o jsonpath='{.status.readyReplicas}')
DESIRED=$(kubectl get deployment chaos-target -o jsonpath='{.spec.replicas}')

echo "Replicas: $READY/$DESIRED"
if [ "$READY" = "$DESIRED" ]; then
  echo "✓ Replica count healthy"
else
  echo "✗ Replica count unhealthy"
  exit 1
fi

# Check 2: Service responding
if kubectl run test --rm -i --image=busybox --restart=Never -- wget -O- --timeout=2 http://chaos-target 2>/dev/null | grep -q "nginx"; then
  echo "✓ Service responding"
else
  echo "✗ Service not responding"
  exit 1
fi

# Check 3: No crashlooping pods
CRASHING=$(kubectl get pods -l app=chaos-target -o json | jq '[.items[] | select(.status.containerStatuses[]?.restartCount > 5)] | length')

if [ "$CRASHING" = "0" ]; then
  echo "✓ No crashlooping pods"
else
  echo "✗ $CRASHING pods crashlooping"
  exit 1
fi

echo "=== Steady State: HEALTHY ==="
EOF

chmod +x /tmp/steady-state-check.sh
/tmp/steady-state-check.sh
```{{exec}}

Steady state validation confirms the system has recovered: replicas are ready, service responds, and no pods are crashlooping.
