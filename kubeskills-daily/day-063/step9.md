## Step 9: Restore working configuration

```bash
# Restore from backup
kubectl apply -f /tmp/coredns-backup.yaml

# Restart CoreDNS
kubectl rollout restart deployment -n kube-system coredns

kubectl wait --for=condition=Ready pod -n kube-system -l k8s-app=kube-dns --timeout=60s

# Verify DNS works
kubectl exec dns-test -- nslookup kubernetes.default.svc.cluster.local
```{{exec}}

Return to a valid Corefile and confirm resolution works again.
