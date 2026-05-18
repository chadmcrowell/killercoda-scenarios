## Step 2 — Identify the Root Cause

Examine the kube-proxy pod logs on the affected node to identify errors. Then inspect the iptables rules on the node to check whether service chain entries exist for your test service. Compare the rules on the broken node to a healthy node.
