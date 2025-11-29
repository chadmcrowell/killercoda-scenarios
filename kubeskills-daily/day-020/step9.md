## Step 9: Check StatefulSet behavior

```bash
kubectl get statefulset stateful-app
kubectl get pods -l app=stateful
```{{exec}}

StatefulSet pods may stay Terminating on the tainted node; they wait for recovery.

```bash
kubectl delete pod stateful-app-0 --grace-period=0 --force
```{{exec}}

StatefulSet immediately creates a replacement.
