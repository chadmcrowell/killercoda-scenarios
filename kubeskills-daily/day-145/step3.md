## Step 3 — Apply the Fix

Apply resource quotas to each namespace limiting their total CPU, memory, and pod count. Deploy a resource-heavy workload in the first namespace and verify it cannot consume beyond its quota. Confirm the second namespace workloads are unaffected.
