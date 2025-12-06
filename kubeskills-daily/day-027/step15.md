## Step 15: Test different request types

```bash
time kubectl get pods
time kubectl get pod <pod-name>

kubectl get pods -w &
WATCH_PID=$!
sleep 5
kill $WATCH_PID 2>/dev/null

time kubectl create configmap test-rate --from-literal=key=val
kubectl delete configmap test-rate
```{{exec}}

List/get/create are rate-limited; watches are usually exempt.
