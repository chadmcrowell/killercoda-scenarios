## Step 2 — Identify the Root Cause

Examine the ClusterRole that was bound to the service account and note which resources and verbs are permitted. Compare this against what the developer application actually needs, which is only the ability to read ConfigMaps and list pods within its own namespace.
