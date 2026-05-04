## Step 2 — Identify the Root Cause

Change the image pull policy on the Deployment from Always to IfNotPresent and trigger a new rollout. Compare the pod startup times before and after the change, noting which nodes already had the image cached versus which ones still needed to pull it. Observe how the pull policy change affects nodes that have never run this workload before.
