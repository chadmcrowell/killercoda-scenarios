## Step 1: Check initial node status

```bash
kubectl get nodes
kubectl describe node $(kubectl get nodes -o jsonpath='{.items[0].metadata.name}') | grep -A 5 Taints
```{{exec}}

Nodes should be Ready with no taints before we simulate failures.
