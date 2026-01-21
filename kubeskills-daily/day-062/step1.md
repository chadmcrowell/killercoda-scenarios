## Step 1: Check current CNI plugin

```bash
# Check CNI configuration
ls -la /etc/cni/net.d/ 2>/dev/null || echo "CNI config not accessible"

# Check CNI pods (usually Calico, Flannel, Cilium, etc.)
kubectl get pods -n kube-system | grep -E "calico|flannel|cilium|weave|canal"

# Get pod CIDR
kubectl cluster-info dump | grep -i cidr
```{{exec}}

Inspect CNI config, CNI pods, and cluster pod CIDR.
