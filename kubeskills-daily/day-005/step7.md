## Step 7: Compare `NoExecute` vs `NoSchedule`

Remove the `NoExecute` taint and add `NoSchedule` instead:

```bash
kubectl taint nodes $NODE dedicated=gpu:NoExecute-
kubectl taint nodes $NODE dedicated=gpu:NoSchedule
```{{exec}}

Force a pod onto that node:

```bash
kubectl run test-pod --image=nginx --overrides='
{
  "spec": {
    "nodeSelector": {
      "kubernetes.io/hostname": "'$NODE'"
    }
  }
}'
```{{exec}}

```bash
kubectl get pod test-pod
```{{exec}}

Pod stays Pending: `NoSchedule` blocks new workloads but does not evict existing ones.
