## Step 13: Check for CNI-related errors in kubelet

```bash
# Check kubelet logs for CNI errors
echo "Checking for CNI errors in kubelet logs:"
echo "(In real clusters, you would check: journalctl -u kubelet | grep CNI)"
echo "Common CNI errors:"
echo "- failed to set up sandbox container network"
echo "- failed to find plugin in path"
echo "- failed to allocate for range"
```{{exec}}

Note common kubelet messages tied to CNI failures.
