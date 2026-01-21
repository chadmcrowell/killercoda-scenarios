## Step 10: Test pod-to-pod connectivity across nodes

```bash
# Get node count
NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)

if [ $NODE_COUNT -gt 1 ]; then
  echo "Multi-node cluster detected"

  # Create pod on each node with nodeSelector
  kubectl label nodes $(kubectl get nodes -o name | head -1 | cut -d'/' -f2) test-node=node1 --overwrite

  kubectl run cross-node-1 --image=nginx --overrides='{"spec":{"nodeSelector":{"test-node":"node1"}}}'

  kubectl wait --for=condition=Ready pod cross-node-1 --timeout=60s

  CROSS_IP=$(kubectl get pod cross-node-1 -o jsonpath='{.status.podIP}')

  # Test from pod on different node
  kubectl exec test-pod-1 -- ping -c 3 $CROSS_IP || echo "Cross-node connectivity issue"
else
  echo "Single-node cluster, skipping cross-node test"
fi
```{{exec}}

Confirm cross-node routing if multiple nodes are available.
