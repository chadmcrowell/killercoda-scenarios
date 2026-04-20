## Step 2 — Identify the Root Cause

Apply a default deny network policy to each namespace that blocks all ingress and egress by default. Then create specific allow rules for traffic that should legitimately flow, such as allowing pods to reach the DNS service in kube-system.
