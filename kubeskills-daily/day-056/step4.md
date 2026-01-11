## Step 4: Test resource fragmentation

```bash
# Delete deployment
kubectl delete deployment resource-hog -n capacity-test

# Create pods with varying sizes
for size in 100m 200m 500m 1000m; do
  kubectl run frag-$size -n capacity-test \
    --image=nginx \
    --requests="cpu=$size,memory=256Mi" \
    --limits="cpu=$size,memory=512Mi"
done

sleep 10

# Try to schedule large pod
kubectl run large-pod -n capacity-test \
  --image=nginx \
  --requests="cpu=2000m,memory=2Gi" \
  --limits="cpu=2000m,memory=2Gi"

# Check status
kubectl get pod large-pod -n capacity-test
kubectl describe pod large-pod -n capacity-test | grep -A 5 "Events:"
```

Fragmentation prevents large pod scheduling.
