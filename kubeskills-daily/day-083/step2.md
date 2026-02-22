## Step 2: Test pod ordering

```bash
echo "Pod creation order:"
kubectl get events --sort-by='.lastTimestamp' | grep "web-" | grep Created

echo ""
echo "StatefulSet guarantees:"
echo "- web-0 created first"
echo "- web-1 created after web-0 is Running"
echo "- web-2 created after web-1 is Running"
echo "- Sequential, ordered deployment"
```{{exec}}

StatefulSets create pods sequentially — each pod must be Running and Ready before the next one starts, guaranteeing ordered startup.
