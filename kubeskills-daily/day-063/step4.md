## Step 4: Simulate CoreDNS pod failure

```bash
# Scale CoreDNS to 0
kubectl scale deployment -n kube-system coredns --replicas=0

# Wait for pods to terminate
sleep 10

# Try DNS resolution (will fail)
kubectl exec dns-test -- nslookup nginx.default.svc.cluster.local 2>&1 || echo "DNS resolution failed!"

# Check timeout
time kubectl exec dns-test -- nslookup nginx.default.svc.cluster.local 2>&1 || echo "DNS timeout"
```{{exec}}

Watch DNS resolution fail when CoreDNS is down.
