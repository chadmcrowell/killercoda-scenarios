## Step 10: Test watch requests

```bash
for i in $(seq 1 10); do
  kubectl get pods -A --watch > /dev/null 2>&1 &
done
sleep 10
pkill -f "kubectl.*watch"
```{{exec}}

```bash
kubectl get --raw /metrics | grep apiserver_longrunning_requests
```{{exec}}

Watches count as long-running requests and consume inflight slots.
