## Step 4: Scale CoreDNS to 0 (break DNS!)

```bash
kubectl scale deployment coredns -n kube-system --replicas=0
sleep 5
kubectl run dnstest2 --rm -it --restart=Never --image=busybox -- nslookup kubernetes.default 2>&1 || echo "DNS failed!"
```{{exec}}

With CoreDNS scaled to zero, DNS queries time out.
