## Step 4: Simulate watch connection overload

```bash
# Multiple watch connections
for i in {1..10}; do
  kubectl get pods -w &
done

sleep 10

# Kill watch processes
killall kubectl

echo "Watch connections:"
echo "- Each watch is a long-lived HTTP connection"
echo "- Too many watches can exhaust connections"
echo "- API server has connection limits"
```{{exec}}

Each watch is a long-lived HTTP connection - too many watches can exhaust API server connection limits.
