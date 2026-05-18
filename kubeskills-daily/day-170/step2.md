## Step 2 — Identify the Root Cause

Delete a Deployment using background propagation and observe that its ReplicaSets and Pods are removed. Then delete a different resource using the orphan propagation policy and confirm that its dependents remain behind as orphaned resources.
