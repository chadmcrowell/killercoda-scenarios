## Step 3 — Apply the Fix

Either scale up the deployment to have more replicas than the minAvailable threshold or reduce the minAvailable value to allow at least one pod to be evicted, then retry the drain and confirm it completes successfully.
