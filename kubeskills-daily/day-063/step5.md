## Step 5: Restore CoreDNS

```bash
# Scale back up
kubectl scale deployment -n kube-system coredns --replicas=2

kubectl wait --for=condition=Ready pod -n kube-system -l k8s-app=kube-dns --timeout=60s

# Test resolution works again
kubectl exec dns-test -- nslookup nginx.default.svc.cluster.local
```{{exec}}

Bring CoreDNS back and confirm DNS recovers.
