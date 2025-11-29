## Step 4: Simulate node failure (taint NotReady)

```bash
NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
kubectl taint nodes $NODE node.kubernetes.io/not-ready:NoExecute --overwrite=true
```{{exec}}

```bash
kubectl get pods -w
```{{exec}}

Pods begin Terminating/Evicted as the NotReady taint triggers eviction.
