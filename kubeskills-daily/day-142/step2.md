## Step 2 — Identify the Root Cause

Delete the PVC bound to the Delete-policy PersistentVolume and observe the status of both the PVC and PV. Note how the PV transitions and whether the underlying storage resource is removed. Then patch a second PV to use the Retain policy.
