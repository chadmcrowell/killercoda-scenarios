## Step 8: View common system taints

```bash
kubectl get nodes -o json | jq -r '.items[].spec.taints'
```{{exec}}

Common ones include `node.kubernetes.io/not-ready`, `unreachable`, `disk-pressure`, and `memory-pressure`.
