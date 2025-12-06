## Step 10: Test throttling with watch

```bash
kubectl get pods -w &
WATCH_PID=$!
sleep 5
kill $WATCH_PID 2>/dev/null
```{{exec}}

Watches are typically exempt from rate limits.
