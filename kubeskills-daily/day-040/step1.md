## Step 1: Check Kubernetes certificate locations

```bash
ls -la /etc/kubernetes/pki/ 2>/dev/null || echo "PKI directory not accessible"
sudo kubeadm certs check-expiration 2>/dev/null || echo "kubeadm not available"
```{{exec}}

See where control plane certs live and when they expire.
