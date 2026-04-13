## Step 1 — Investigate the Problem

Identify which pods are currently running on the target node and determine which ones are part of managed workloads like Deployments or StatefulSets versus standalone pods. Check whether any of these workloads have Pod Disruption Budgets and whether eviction is currently permitted.
