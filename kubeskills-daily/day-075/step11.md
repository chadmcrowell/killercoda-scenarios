## Step 11: Test log volume issues

```bash
# Create pod with excessive logging
kubectl run noisy-logger --image=busybox --command -- sh -c '
while true; do
  for i in $(seq 1 100); do
    echo "Log message $i at $(date)"
  done
  sleep 0.1
done'

sleep 10

# Check log output rate
kubectl logs noisy-logger --tail=100 | wc -l

echo ""
echo "Excessive logging causes:"
echo "- Disk fills up"
echo "- Log aggregation overwhelmed"
echo "- Storage costs spike"
echo "- Important logs buried"

kubectl delete pod noisy-logger
```{{exec}}

Excessive logging can overwhelm systems and hide important messages.
