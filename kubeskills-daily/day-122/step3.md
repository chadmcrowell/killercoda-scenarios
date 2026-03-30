## Step 3 — Apply the Fix

Remediate the issue by either mounting an emptyDir volume for temporary data to move it off the container writable layer, increasing the ephemeral storage limit to match actual usage, or both, then confirm the pod runs without being evicted.
