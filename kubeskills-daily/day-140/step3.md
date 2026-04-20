## Step 3 — Apply the Fix

Decide on a resolution strategy. Either patch the readiness probe to match the correct endpoint and allow the rollout to continue, or use a rollout undo command to revert to the last known good revision. Confirm the deployment reaches its desired replica count with all pods Ready.
