## Step 10: Examine pod network from the node

```bash
# Requires node access; simulated here
# ip netns list
# nsenter -t <pid> -n ip addr
# ip link show | grep -i cni
# brctl show
```

These commands inspect pod namespaces and CNI bridges from the node side.
