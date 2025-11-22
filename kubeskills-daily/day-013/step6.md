## Step 6: Drain should work now

```bash
# Uncordon first if prior drain partially cordoned the node
kubectl uncordon $NODE
```{{exec}}

```bash
kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data --timeout=60s
```{{exec}}

With a disruption budget of 1, eviction and rescheduling should succeed.
