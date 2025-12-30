## Step 10: Force delete stuck pod

```bash
kubectl delete pod stateful-app-0 --grace-period=0 --force
kubectl get pods -l app=stateful -w
```{{exec}}

Force deletion lets the StatefulSet create a replacement on a healthy node.
