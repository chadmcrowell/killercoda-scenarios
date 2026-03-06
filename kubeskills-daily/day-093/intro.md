# Day 93 — Namespace Resource Quota Exhaustion Debugging

The application team filed an urgent ticket: their `api-server` Deployment is stuck at 2 replicas instead of 4, and a scale-out event is starting in 20 minutes. The cluster nodes have plenty of available capacity. No pods are evicted. No OOM kills.

But the pods won't come up.

The namespace has a `ResourceQuota` in place. Another team member deployed a `cache` service earlier today that "doesn't use any resources." The quota math doesn't add up to anyone on the team — and that's exactly the problem.

In this scenario you will:

- Build a namespace with a ResourceQuota and LimitRange and observe how they interact
- Deploy pre-existing workloads that consume quota, including one that silently consumes it through LimitRange injection
- Trace the quota failure chain from Deployment → ReplicaSet events → API server rejection
- Calculate exact quota headroom and choose the right fix under time pressure

Click **Start** to begin.
