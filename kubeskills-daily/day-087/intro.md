# Day 87 — DaemonSet Failures: When Node-Level Pods Won't Deploy

The observability team deployed two DaemonSets to collect metrics and logs from every node in the cluster. Neither is working.

- `node-exporter` shows **0 desired pods** — the controller isn't even trying to create any
- `log-collector` shows **2 desired, 0 ready** — both pods are stuck in Pending and never start

The on-call rotation begins soon and the team is flying blind with no node metrics or logs. Your job is to figure out what's blocking each DaemonSet and get both running.

In this scenario you will:

- Deploy two broken DaemonSets and observe their contrasting failure symptoms
- Diagnose a `nodeSelector` misconfiguration that produces DESIRED=0
- Diagnose taint/toleration mismatches that leave pods permanently Pending
- Fix both DaemonSets and verify every expected node has a running pod

Click **Start** to begin.