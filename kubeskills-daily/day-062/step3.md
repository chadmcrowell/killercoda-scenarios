## Step 3: Check CNI binary and config

```bash
# Check CNI binaries
ls -la /opt/cni/bin/ 2>/dev/null || echo "CNI binaries not accessible"

# Check CNI config files
cat /etc/cni/net.d/*.conf* 2>/dev/null || echo "CNI config not accessible"
```{{exec}}

Confirm CNI binaries and config files are present.
