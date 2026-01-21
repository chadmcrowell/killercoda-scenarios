## Step 14: Check CSI driver health

```bash
# Check for CSI driver pods
kubectl get pods -A | grep csi

# Check CSI node pods (one per node)
kubectl get pods -A | grep "csi-node\|csi-attacher\|csi-provisioner"

# If CSI driver down, volume operations fail
```{{exec}}

Verify CSI driver components are healthy.
