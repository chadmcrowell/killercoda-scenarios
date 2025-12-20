## Step 5: Restore CoreDNS

```bash
kubectl scale deployment coredns -n kube-system --replicas=2
kubectl wait --for=condition=Ready pods -l k8s-app=kube-dns -n kube-system --timeout=60s
kubectl run dnstest3 --rm -it --restart=Never --image=busybox -- nslookup kubernetes.default
```{{exec}}

DNS works again after CoreDNS pods recover.
