## Step 1: Check CoreDNS configuration

```bash
kubectl get configmap coredns -n kube-system -o yaml
```{{exec}}

Look for the `ttl` in the Corefile (defaults to ~30s), which affects caching behavior.
