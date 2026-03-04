# Day 91 — Pod Pending Due to Node Selector Mismatch

The infrastructure team just completed a node labeling migration to enable hardware-aware scheduling. Three Deployments were written to target specific node types — but every single pod across all three Deployments is stuck in Pending. The cluster is healthy, there are no resource shortages, and nobody can explain why nothing is running.

This scenario has three layers of failure, each requiring a different investigative path and fix. Work through them in order.

In this scenario you will:

- Deploy three Deployments against a partially-migrated cluster and observe all pods stuck in Pending
- Diagnose a missing label, a wrong label value, and a label-plus-taint combination blocking scheduling
- Learn how to extract node selector constraints from Deployment specs and cross-reference them against real node labels
- Choose the right fix strategy for each failure — label the node, correct the label value, or remove a blocking taint

Click **Start** to begin.
