## Step 3 — Apply the Fix

Delete the production-critical namespace to simulate data loss, then stop the API server, restore etcd from your snapshot file using etcdctl snapshot restore, update the etcd static pod manifest to point to the restored data directory, and restart the API server.
