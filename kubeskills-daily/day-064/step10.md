## Step 10: Test volume attachment limits

```bash
# Simulate hitting volume limit (concept)
echo "Volume attachment limits per node:"
echo "- AWS EBS: 39 volumes per instance"
echo "- GCP PD: 127 volumes per node"
echo "- Azure Disk: 64 volumes per node"
echo ""
echo "When limit reached:"
echo "- New PVCs remain Pending"
echo "- Pods stuck in ContainerCreating"
echo "- Error: 'AttachVolume.Attach failed: Maximum number of volumes reached'"
```{{exec}}

Understand common cloud volume attachment limits and symptoms.
