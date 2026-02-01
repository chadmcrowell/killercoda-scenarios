## Step 13: Check storage class changes

```bash
# Default storage class behavior changed in some versions
kubectl get storageclass

# Check for deprecated provisioners
kubectl get storageclass -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.provisioner}{"\n"}{end}'
```{{exec}}

Storage provisioners migrating from in-tree to CSI drivers.
