## Step 3 — Apply the Fix

Modify the Pod Disruption Budget to allow the autoscaler to evict at least one pod while still maintaining meaningful availability protection. Verify that the autoscaler can now identify the node as a valid scale-down candidate.
