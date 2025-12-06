## Step 13: Monitor kubelet eviction logs

```bash
kubectl get pods -A | grep Evicted
kubectl describe pod <evicted-pod> | grep -A 5 "Reason:"
```{{exec}}

On node (if accessible): `journalctl -u kubelet | grep -i evict`.
