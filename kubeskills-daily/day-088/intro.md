# Day 88 — HPA Edge Cases: When Autoscaling Makes Things Worse

The platform team deployed Horizontal Pod Autoscalers on two services to automatically scale under load. Both HPAs are reporting `<unknown>` for their current metrics target — autoscaling is completely inactive for both services, and nobody knows why.

In this scenario you will:

- Deploy two Deployments with HPAs and observe both stuck at `<unknown>` targets
- Diagnose a cluster-wide issue preventing all HPAs from collecting metrics
- Diagnose a per-Deployment misconfiguration that prevents utilization-based scaling
- Install the fix for the cluster, patch the broken Deployment, and verify both HPAs are healthy

Click **Start** to begin.