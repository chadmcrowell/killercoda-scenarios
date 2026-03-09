## Step 2 — Identify the Root Cause

Add a preStop lifecycle hook to the deployment container that introduces a short sleep before the container begins shutting down. This sleep gives the endpoint controller and kube-proxy time to remove the pod from load balancer rotation before the application stops accepting connections.
