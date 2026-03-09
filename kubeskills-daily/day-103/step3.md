## Step 3 — Apply the Fix

Drain one of the nodes with problematic version skew to safely evict its workloads. Perform the kubelet and kube-proxy upgrade on that node and then bring it back into the cluster. Verify its version is now within the supported skew boundary and re-enable scheduling.
