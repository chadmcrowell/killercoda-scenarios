## Step 3 — Apply the Fix

Create a new StorageClass configured with the Retain reclaim policy to protect a production database workload. Deploy a StatefulSet that uses this StorageClass for its volume claim template. Delete the StatefulSet and confirm that the PVCs and their data are preserved according to the Retain policy rather than being automatically cleaned up.
