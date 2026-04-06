## Step 1 — Investigate the Problem

Examine each of the three stuck terminating pods using describe and look at their metadata finalizers field, the status of the node they were scheduled on, and any events related to their termination sequence. Document the different root cause for each pod before taking any action.
