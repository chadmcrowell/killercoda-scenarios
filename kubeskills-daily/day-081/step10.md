## Step 10: Simulate node failure

```bash
# Cordon node to simulate failure
NODE=$(kubectl get nodes -o name | head -1)

if [ -n "$NODE" ]; then
  echo "Simulating $NODE failure:"
  echo "1. Cordon node (prevent new pods)"
  echo "   kubectl cordon $NODE"
  echo ""
  echo "2. Drain node (evict pods)"
  echo "   kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data"
  echo ""
  echo "3. Observe:"
  echo "   - Pods rescheduled to other nodes?"
  echo "   - StatefulSets stuck?"
  echo "   - Services remain available?"
  echo ""
  echo "4. Uncordon to restore"
  echo "   kubectl uncordon $NODE"
fi
```{{exec}}

Node failure simulation tests pod rescheduling, StatefulSet behavior, and service availability during infrastructure outages.
