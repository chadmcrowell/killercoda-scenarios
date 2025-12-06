## Step 5: Count iptables rules

```bash
kubectl exec iptables-viewer -- iptables-save | wc -l
```{{exec}}

Large clusters may have thousands of rules (O(n) with services/endpoints).
