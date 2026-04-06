## Step 2 — Identify the Root Cause

Delete the second PVC which is bound to a volume with the Retain policy. Observe that the PV moves to Released state and the data is preserved. Practice manually reclaiming this volume by editing the PV to remove its claimRef field, confirm it returns to Available state, and then create a new PVC that successfully binds to the reclaimed volume.
