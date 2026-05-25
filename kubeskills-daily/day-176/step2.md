## Step 2 — Identify the Root Cause

Identify the reason recorded in the autoscaler logs for why scale-up was skipped. Common reasons include no node group can satisfy the pod constraints, all node groups are at maximum size, or the pod has a node selector that does not match any configured node group label.
