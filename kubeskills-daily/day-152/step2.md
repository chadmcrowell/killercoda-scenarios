## Step 2 — Identify the Root Cause

Examine the termination grace period setting on the affected pods and add a pre-stop hook that introduces a short sleep to allow the load balancer to drain connections before the application begins shutting down.
