## Step 13: Uncordon and cleanup

```bash
kubectl uncordon $NODE
kubectl delete pod patient-pod immortal-pod 2>/dev/null
kubectl delete deployment default-app
kubectl delete statefulset stateful-app
kubectl delete daemonset node-monitor
kubectl delete service stateful
```{{exec}}

Restore scheduling and remove lab resources.
