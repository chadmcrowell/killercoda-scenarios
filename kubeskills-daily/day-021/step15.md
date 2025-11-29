## Step 15: Find all stuck resources in Terminating state

```bash
kubectl get namespaces | grep Terminating
kubectl get pods --all-namespaces -o json | jq -r '.items[] | select(.metadata.deletionTimestamp != null) | "\\(.metadata.namespace)/\\(.metadata.name)"'
kubectl get configmaps --all-namespaces -o json | jq -r '.items[] | select(.metadata.finalizers != null) | "\\(.metadata.namespace)/\\(.metadata.name): \\(.metadata.finalizers)"'
```{{exec}}

Use queries to hunt down resources blocked by finalizers or deletion timestamps.
