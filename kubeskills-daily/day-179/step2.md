## Step 2 — Identify the Root Cause

Create a Network Policy that selects all pods in the namespace and specifies an empty egress array to block all outbound connections. Immediately after applying it, test the same outbound connections and confirm they now fail. Also confirm that DNS resolution breaks because the CoreDNS egress is now blocked.
