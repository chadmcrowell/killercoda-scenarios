## Step 2 — Identify the Root Cause

Inspect the etcd database size and revision count. Trigger a compaction operation to remove old revisions that are no longer needed and observe how this affects the database size and subsequent request latency metrics.
