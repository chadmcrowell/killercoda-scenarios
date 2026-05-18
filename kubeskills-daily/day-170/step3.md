## Step 3 — Apply the Fix

Manually clean up the orphaned ReplicaSets and completed Job pods by deleting them directly. Then update a Deployment to set a lower revision history limit and verify that old ReplicaSets beyond that limit are removed automatically.
