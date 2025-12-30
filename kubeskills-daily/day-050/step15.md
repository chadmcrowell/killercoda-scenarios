## Step 15: Check node pressure eviction

```bash
kubectl describe nodes | grep -E "MemoryPressure|DiskPressure|PIDPressure"
kubectl get --raw /api/v1/nodes/$NODE/proxy/configz | jq '.kubeletconfig.evictionHard' 2>/dev/null || echo "Configz not available"
```{{exec}}

Review node pressure conditions and kubelet eviction thresholds.
