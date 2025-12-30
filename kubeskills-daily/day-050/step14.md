## Step 14: Simulate multiple node failures

```bash
NODES=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')
for node in $NODES; do
  kubectl taint nodes $node node.kubernetes.io/unreachable:NoExecute --overwrite &
done

kubectl get pods -A -w

for node in $NODES; do
  kubectl taint nodes $node node.kubernetes.io/unreachable:NoExecute- 2>/dev/null
done
```{{exec}}

A taint on all nodes triggers an eviction storm; cleanup taints afterward.
