## Step 2: Test basic DNS resolution

```bash
kubectl run dnstest --rm -it --restart=Never --image=busybox -- nslookup kubernetes.default
```{{exec}}

Should resolve to the ClusterIP of the Kubernetes service.
