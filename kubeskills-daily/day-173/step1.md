## Step 1 — Investigate the Problem

Inspect the Lease objects in the kube-system namespace to identify which instances of the scheduler and controller manager currently hold leadership. Note the holder identity, acquire time, and renew time fields to understand the lease state.
