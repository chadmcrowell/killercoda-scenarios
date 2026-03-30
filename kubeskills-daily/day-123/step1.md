## Step 1 — Investigate the Problem

Inspect the StatefulSet and identify which pods are not in Running state, then check the PVC status for each affected replica to determine whether the PVCs are in Pending, Lost, or another non-Bound state.
