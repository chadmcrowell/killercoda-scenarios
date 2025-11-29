## Step 11: Test pod disruption during node drain

```bash
kubectl taint nodes $NODE node.kubernetes.io/not-ready:NoExecute- 2>/dev/null
sleep 30
kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data --timeout=60s --grace-period=30
```{{exec}}

Deployment pods reschedule; StatefulSet pods move; DaemonSet pods stay because they are ignored by drain.
