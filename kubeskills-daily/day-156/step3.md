## Step 3 — Apply the Fix

Create a new StorageClass with a Retain reclaim policy and label it as the default for stateful workloads. Deploy a test StatefulSet using this StorageClass, write data to the volume, then delete the StatefulSet and its PVCs. Confirm the underlying PV and storage resource are preserved and the data can be recovered using the rebinding process from the previous step.
