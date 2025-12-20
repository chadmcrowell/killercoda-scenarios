## Step 2: Check API server certificate

```bash
kubectl cluster-info | grep "Kubernetes control plane"

echo | openssl s_client -connect localhost:6443 2>/dev/null | openssl x509 -noout -dates
```{{exec}}

Verify API server endpoint and current certificate validity (if accessible).
