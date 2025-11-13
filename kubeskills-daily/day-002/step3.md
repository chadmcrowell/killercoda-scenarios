## Step 3: Force-delete `web-1` while `web-2` is starting

Wait until `web-1` is Running and `web-2` shows `ContainerCreating`, then blast `web-1` out of the cluster:

```bash
kubectl delete pod web-1 --grace-period=0 --force
```{{exec}}

`web-2` remains stuck because StatefulSets refuse to advance while a lower ordinal is unhealthy.
