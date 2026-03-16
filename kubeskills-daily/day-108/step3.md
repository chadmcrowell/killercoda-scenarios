## Step 3 — Apply the Fix

Update the identified deployments to set automountServiceAccountToken to false at the pod spec level, trigger rollouts, and verify that the new pods no longer have the token volume mounted in their filesystem.
