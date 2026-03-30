## Step 2 — Identify the Root Cause

Examine the pod anti-affinity rule in the deployment specification, noting whether it is required or preferred and what topology key is being used, then verify the node count against the replica count to confirm the deadlock condition.
