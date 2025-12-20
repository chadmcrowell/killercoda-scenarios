## Step 13: Check memory vs swap

```bash
kubectl describe node | grep -i swap
```{{exec}}

Kubernetes expects swap disabled; verify swap status on the node.
