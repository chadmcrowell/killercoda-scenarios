## Step 14: Test volume plugin migration

```bash
# In-tree volume plugins migrating to CSI
echo "Volume plugin migrations:"
echo "- AWS EBS: In-tree deprecated, use CSI driver"
echo "- GCE PD: In-tree deprecated, use CSI driver"
echo "- Azure Disk: In-tree deprecated, use CSI driver"
echo ""
echo "After migration, old provisioner names may not work"

# Example: Old vs new
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: test-storage
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
EOF
```{{exec}}

In-tree volume plugins being replaced by CSI drivers.
