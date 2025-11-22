## Step 3: Immediately try to resolve DNS

```bash
kubectl run dns-test --rm -it --restart=Never --image=busybox -- nslookup backend-svc
```{{exec}}

Run this right after creation; if endpoints aren't ready yet you may see `NXDOMAIN` or an empty response.
