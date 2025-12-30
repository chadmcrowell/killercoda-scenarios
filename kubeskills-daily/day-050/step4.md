## Step 4: Cordon node (prevent new scheduling)

```bash
NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
kubectl cordon $NODE
kubectl get nodes
```{{exec}}

Node shows SchedulingDisabled and will not receive new pods.
