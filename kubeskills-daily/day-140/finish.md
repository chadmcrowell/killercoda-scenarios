## Lab Complete 🎉

**Verification:** The deployment should show all replicas as updated and available, no pods should be in a CrashLoopBackOff or not-Ready state, and rollout status should report the rollout as successfully completed.

### What You Learned

How maxUnavailable and maxSurge values in a rolling update strategy control the pace of a rollout
Why a failing readiness probe blocks a rollout from completing rather than just marking pods unhealthy
How to use rollout status and rollout history commands to understand the current state of a deployment
When to use rollout undo versus fixing forward to resolve a stuck update
How deployment revision history helps you understand what changed between working and broken versions

### Why It Matters

A rollout stuck at 50 percent means your users may be routed to either the old or new version depending on which replica serves them, creating inconsistent behavior that is nearly impossible to debug from the user perspective. If the new version introduced a critical bug, every minute the rollout stays frozen is another minute of user-facing errors.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
