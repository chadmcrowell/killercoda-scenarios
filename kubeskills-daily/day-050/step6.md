## Step 6: Uncordon node

```bash
kubectl uncordon $NODE
kubectl get pods -l app=multi-node -o wide
```{{exec}}

Uncordoned nodes do not automatically rebalance existing pods.
