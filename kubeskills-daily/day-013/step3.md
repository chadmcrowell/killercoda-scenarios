## Step 3: Try to drain a node

```bash
NODE=$(kubectl get pods -l app=critical-app -o jsonpath='{.items[0].spec.nodeName}')
echo "Draining node: $NODE"
```{{exec}}

```bash
kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data --timeout=30s
```{{exec}}

Drain should hang and time out after ~30s because the PDB forbids evictions.
