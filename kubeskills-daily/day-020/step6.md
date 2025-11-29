## Step 6: Remove taint and watch recovery

```bash
kubectl taint nodes $NODE node.kubernetes.io/not-ready:NoExecute-
```{{exec}}

```bash
kubectl get pods -o wide -w
```{{exec}}

Deployment pods reschedule; StatefulSet pods attempt to return to original node.
