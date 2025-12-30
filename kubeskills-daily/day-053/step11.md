## Step 11: Test service endpoint updates during partition (conceptual)

```bash
echo "During partition:"
echo "- New pods may not appear in endpoints"
echo "- Traffic may route to stale endpoints"
echo "- DNS may serve outdated records"
```{{exec}}

Endpoints can lag when controllers/kube-proxy are partitioned.
