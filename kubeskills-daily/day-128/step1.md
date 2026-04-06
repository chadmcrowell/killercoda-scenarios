## Step 1 — Investigate the Problem

Locate the etcd static pod manifest to find the etcd endpoint address and the paths to the CA certificate, client certificate, and client key. Use the etcdctl tool with these parameters to take a snapshot and save it to a specific path on the control plane node. Verify the snapshot file exists and check its status to confirm it is valid.
