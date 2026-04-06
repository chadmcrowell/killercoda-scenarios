## Step 3 — Apply the Fix

Update the etcd static pod manifest to point its data directory path to the newly restored directory. Wait for kubelet to detect the manifest change and restart the etcd static pod. Once etcd is back up, verify that the API server reconnects and that the previously deleted workloads are visible and running again.
