## Step 2 — Identify the Root Cause

Examine the ClusterRole referenced in the problematic binding and document all the permissions it grants. Note how wildcard entries for verbs and resources differ from explicitly named permissions, and identify the specific resources and verbs that are excessive for a deployment operator role.
