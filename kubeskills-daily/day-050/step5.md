## Step 5: Drain node gracefully

```bash
kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data --grace-period=30
kubectl get pods -l app=multi-node -o wide -w
```{{exec}}

Pods evict and reschedule to other nodes; DaemonSets are ignored.
