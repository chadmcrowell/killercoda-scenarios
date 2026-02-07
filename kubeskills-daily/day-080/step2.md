## Step 2: Simulate API request spam

```bash
# Create many resources rapidly
for i in {1..100}; do
  kubectl create configmap spam-$i --from-literal=key=value &
done

# Wait for all background jobs
wait

echo "Created 100 ConfigMaps"
kubectl get configmaps | grep spam | wc -l

# This generates many API requests
# Large numbers can hit rate limits
```{{exec}}

Rapidly creating many resources generates a burst of API requests that can trigger rate limiting.
