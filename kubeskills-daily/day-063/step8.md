## Step 8: Check CoreDNS logs for errors

```bash
# Check logs for configuration errors
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=50 | grep -i "error\|fail\|invalid"
```{{exec}}

Identify parsing errors in CoreDNS logs.
