## Step 10: Test kubectl client-side throttling

```bash
# Run multiple kubectl commands concurrently
for i in {1..50}; do
  kubectl get nodes > /dev/null 2>&1 &
done

wait

echo "Client-side throttling:"
echo "- kubectl limits itself (default 5 QPS)"
echo "- Prevents overwhelming server"
echo "- Can be adjusted with --request-timeout"
echo "- Configured in kubeconfig"
```{{exec}}

kubectl has built-in client-side throttling (default 5 QPS) to prevent overwhelming the API server.
