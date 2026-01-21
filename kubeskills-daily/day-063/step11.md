## Step 11: Test ndots behavior

```bash
# Restore working config
kubectl apply -f /tmp/coredns-backup.yaml
kubectl rollout restart deployment -n kube-system coredns
kubectl wait --for=condition=Ready pod -n kube-system -l k8s-app=kube-dns --timeout=60s

# Check default ndots (usually 5)
kubectl exec dns-test -- cat /etc/resolv.conf | grep ndots

# Show the query pattern
kubectl exec dns-test -- sh -c 'nslookup google.com 2>&1 | grep -E "Server:|Name:"'
```{{exec}}

Review ndots and how it expands DNS queries.
