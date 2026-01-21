## Step 2: Check ImagePullBackOff backoff timing

```bash
# Watch backoff progression
kubectl get pod nonexistent -w &
WATCH_PID=$!

sleep 30
kill $WATCH_PID 2>/dev/null

# Check events to see backoff
kubectl get events --field-selector involvedObject.name=nonexistent --sort-by='.lastTimestamp' | tail -10
```{{exec}}

Review the exponential backoff pattern from events.
