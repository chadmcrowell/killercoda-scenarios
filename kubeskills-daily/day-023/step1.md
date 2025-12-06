## Step 1: Check current CNI plugin

```bash
ls -la /etc/cni/net.d/
cat /etc/cni/net.d/*.conf* 2>/dev/null || echo "CNI config location varies"
ls -la /opt/cni/bin/ 2>/dev/null || ls -la /usr/lib/cni/ 2>/dev/null
```{{exec}}

Inspect configs and binaries to see which CNI is installed.
