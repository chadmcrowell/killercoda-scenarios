## Step 7: Inspect CNI plugin logs

```bash
# On the node (if accessible):
# journalctl -u kubelet | grep -i cni

kubectl get nodes
kubectl describe node $(kubectl get nodes -o jsonpath='{.items[0].metadata.name}') | grep -i network
```{{exec}}

Use node logs or describe output to spot CNI-related messages.
