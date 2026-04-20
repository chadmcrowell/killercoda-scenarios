## Step 2 — Identify the Root Cause

Use kubeadm to renew all certificates at once. Observe the output and note which certificates were renewed successfully. After renewal, restart the static pod components that cache the old certificate data by moving and restoring their manifest files.
