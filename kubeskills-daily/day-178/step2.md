## Step 2 — Identify the Root Cause

Update the active Deployment objects in the default namespace to set a revisionHistoryLimit of three. Enable the TTL controller feature by annotating existing completed Jobs with a TTL value and creating new Jobs with the TTL seconds after finished field set to a short duration.
