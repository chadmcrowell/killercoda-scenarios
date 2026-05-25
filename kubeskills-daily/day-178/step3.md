## Step 3 — Apply the Fix

Safely delete the orphaned PersistentVolumeClaims that are in Released or Failed states after confirming no running pod references them. Delete the completed Job objects that have exceeded a reasonable retention window and verify the associated pods are also removed.
