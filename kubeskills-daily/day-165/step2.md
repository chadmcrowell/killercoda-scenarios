## Step 2 — Identify the Root Cause

Identify the IP address range and port used by CoreDNS pods in the kube-system namespace, then write a new network policy that adds an egress rule specifically permitting UDP and TCP traffic on port 53 to the CoreDNS pods.
