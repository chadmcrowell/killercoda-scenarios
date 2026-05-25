## Step 1 — Investigate the Problem

Count the completed Job objects and their associated pods across all namespaces. Also list the ReplicaSet objects and note how many have zero desired replicas, indicating they are old revision history. Note the PersistentVolumeClaims in Released or Failed states.
