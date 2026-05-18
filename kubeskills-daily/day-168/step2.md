## Step 2 — Identify the Root Cause

Attempt to deploy a high-priority production pod that requires resources currently unavailable on the node. Observe the pod remaining in a Pending state briefly and then watch as the scheduler selects lower-priority pods for preemption.
