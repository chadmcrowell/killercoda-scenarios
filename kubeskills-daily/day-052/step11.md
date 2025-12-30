## Step 11: Simulate quorum loss (conceptual)

```bash
echo "Quorum loss simulation:"
echo "3-member cluster needs 2 healthy members (N/2 + 1)"
echo "5-member cluster needs 3 healthy members"
echo "Stopping enough members to lose quorum freezes the cluster"
```{{exec}}

Quorum loss means no reads/writes until members return.
