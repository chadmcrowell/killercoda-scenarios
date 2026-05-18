## Step 1 — Investigate the Problem

List all ReplicaSets in the target namespace and identify which ones are orphaned, meaning they have no owner reference pointing to an existing Deployment. Also identify completed Jobs and their associated Pods that have not been garbage collected.
