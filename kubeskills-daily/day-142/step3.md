## Step 3 — Apply the Fix

Delete the PVC bound to the Retain-policy PersistentVolume and observe that the PV moves to Released status rather than being deleted. Manually reclaim the PV by clearing its claimRef and create a new PVC that binds to it. Confirm the previously written data is still accessible.
