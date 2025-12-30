## Step 1: Check Kubernetes certificate expiration

```bash
sudo kubeadm certs check-expiration 2>/dev/null || echo "kubeadm not available or not sudo access"

echo | openssl s_client -connect localhost:6443 2>/dev/null | openssl x509 -noout -dates
```{{exec}}

Inspect cluster and API server cert expirations (if accessible).
