## Step 2 — Identify the Root Cause

Delete or scale down the runaway logging workload to stop it from writing more data. Verify that the disk usage on the node drops back below the eviction threshold and that the DiskPressure condition clears. Check that the taint kubelet applied to the node during disk pressure is removed automatically.
