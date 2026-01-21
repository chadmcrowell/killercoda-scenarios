## Step 15: Diagnose storage issues

```bash
cat > /tmp/storage-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Storage Diagnosis Report ==="

echo -e "\n1. StorageClasses:"
kubectl get storageclass

echo -e "\n2. Pending PVCs:"
kubectl get pvc -A --field-selector status.phase=Pending

echo -e "\n3. Unbound PVs:"
kubectl get pv --field-selector status.phase=Available

echo -e "\n4. Recent PVC Events:"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i "persistentvolumeclaim\|pvc" | tail -10

echo -e "\n5. Pods Waiting for Volumes:"
kubectl get pods -A -o json | jq -r '
  .items[] | 
  select(.status.conditions[]? | .type == "PodScheduled" and .reason == "Unschedulable") | 
  "\(.metadata.namespace)/\(.metadata.name): \(.status.conditions[] | select(.type == "PodScheduled").message)"
' | grep -i volume || echo "No pods waiting for volumes"

echo -e "\n6. Volume Attachment Status:"
kubectl get volumeattachment 2>/dev/null | head -10 || echo "VolumeAttachments not available"

echo -e "\n7. Storage Capacity:"
kubectl get pv -o custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage,STATUS:.status.phase

echo -e "\n8. Common Storage Issues:"
echo "   - Wrong StorageClass: PVC pending"
echo "   - No provisioner: Dynamic provisioning fails"
echo "   - Volume limit reached: Attachments fail"
echo "   - Access mode mismatch: PVC won't bind"
echo "   - CSI driver down: All storage operations fail"
echo "   - Wrong ReclaimPolicy: Data deleted unintentionally"
EOF

chmod +x /tmp/storage-diagnosis.sh
/tmp/storage-diagnosis.sh
```{{exec}}

Run a storage diagnosis script to surface common problems.
