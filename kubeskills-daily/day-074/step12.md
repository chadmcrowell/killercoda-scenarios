## Step 12: Test cross-region backup

```bash
# Conceptual: Backups in same region as cluster
echo "Backup location risks:"
echo "- Same region as cluster: Lost in regional outage"
echo "- Same availability zone: Lost in AZ failure"
echo "- Same storage class: Lost if storage fails"
echo ""
echo "Best practice: Cross-region backup storage"
```{{exec}}

Cross-region backups protect against regional failures.
