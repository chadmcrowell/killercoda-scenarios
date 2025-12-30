## Step 8: Remove taint to recover

```bash
kubectl taint nodes $NODE node.kubernetes.io/unreachable:NoExecute-
kubectl get nodes
```{{exec}}

Pods scheduled elsewhere stay put; taint removal restores scheduling.
