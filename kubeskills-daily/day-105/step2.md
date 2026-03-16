## Step 2 — Identify the Root Cause

Examine the deployment that should be running on the tainted node and check whether its pod spec includes any tolerations, then identify exactly which taint key, value, and effect are missing from the toleration list.
