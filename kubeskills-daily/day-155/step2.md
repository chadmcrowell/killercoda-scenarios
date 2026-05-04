## Step 2 — Identify the Root Cause

Examine the kubelet configuration on the affected node to understand the default eviction thresholds that were triggered. Compare the node allocatable memory against the actual consumption shown in node metrics, and explain why a pod with a memory limit set can still be evicted when the node itself is under pressure.
