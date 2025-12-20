## Step 14: Check CoreDNS resource usage

```bash
kubectl get deployment coredns -n kube-system -o yaml | grep -A 10 resources
kubectl top pods -n kube-system -l k8s-app=kube-dns || true
```{{exec}}

Inspect current resource requests/limits and live usage.
