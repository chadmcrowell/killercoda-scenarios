## Step 10: Simulate controller partition (conceptual)

```bash
echo "Controller partition effects:"
echo "- Deployments wouldn't scale"
echo "- Failed pods wouldn't restart"
echo "- Services wouldn't update endpoints"
echo "- Controllers retry until reconnected"
```{{exec}}

Controllers rely on API connectivity; partitions stall reconciliation.
