## Step 2 — Identify the Root Cause

Delete several deployments and their associated services and config maps across multiple namespaces to simulate a data loss scenario. Confirm they are gone, then use the etcdctl snapshot restore command to extract the snapshot into a new data directory on the control plane node.
