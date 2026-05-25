## Step 1 — Investigate the Problem

Verify the current state of egress from a pod in the target namespace by attempting connections to a well-known external address and to an internal service in a different namespace. Confirm that both succeed without restriction. List any existing Network Policies and note they cover only ingress traffic.
