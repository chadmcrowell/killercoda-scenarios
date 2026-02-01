## Step 6: Generate load to trigger scaling

```bash
# Generate load
kubectl run -it load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done" &
LOAD_PID=$!

# Watch HPA scale
kubectl get hpa php-apache-hpa -w &
WATCH_PID=$!

sleep 60

# Stop load and watch
kill $LOAD_PID 2>/dev/null
sleep 30
kill $WATCH_PID 2>/dev/null
```{{exec}}

Generate CPU load and watch HPA react.
