## Step 4: Inspect pod network namespace

```bash
kubectl exec nettest-1 -- ip addr show
kubectl exec nettest-1 -- ip route show
kubectl exec nettest-1 -- ip link show
```{{exec}}

Expect an eth0 with the pod IP and a default route via the CNI bridge/overlay.
