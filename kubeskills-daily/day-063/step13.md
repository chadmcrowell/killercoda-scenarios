## Step 13: Test DNS caching

```bash
# Restore working config
kubectl apply -f /tmp/coredns-backup.yaml
kubectl rollout restart deployment -n kube-system coredns
kubectl wait --for=condition=Ready pod -n kube-system -l k8s-app=kube-dns --timeout=60s

# Query same domain multiple times
for i in {1..5}; do
  time kubectl exec dns-test -- nslookup google.com 2>&1 | grep "Server:"
done

# First query slower (cache miss), subsequent faster (cache hit)
```{{exec}}

Observe cache effects on repeated lookups.
