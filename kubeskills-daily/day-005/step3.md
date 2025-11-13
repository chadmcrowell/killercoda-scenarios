## Step 3: Verify the taint

```bash
kubectl describe node $NODE | grep Taints
```{{exec}}

Expect `dedicated=gpu:NoExecute`.
