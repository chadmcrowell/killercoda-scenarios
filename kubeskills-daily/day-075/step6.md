## Step 6: Test metrics storage exhaustion

```bash
echo "Prometheus storage issues:"
echo "- Default retention: 15 days"
echo "- Storage full = oldest data deleted"
echo "- No storage = metrics collection stops"
echo ""
echo "Symptoms:"
echo "- Queries return incomplete data"
echo "- Gaps in dashboards"
echo "- Alerts don't fire (missing data)"
```{{exec}}

Storage exhaustion causes data loss and gaps.
