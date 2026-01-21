## Step 12: Test DNS resolution (depends on CNI)

```bash
# DNS should work with functioning CNI
kubectl run dns-test --rm -it --image=busybox --restart=Never -- nslookup kubernetes.default.svc.cluster.local

# Test from existing pod
kubectl exec test-pod-1 -- nslookup kubernetes.default 2>&1 || echo "DNS resolution failed"
```{{exec}}

Validate cluster DNS resolution from pods.
