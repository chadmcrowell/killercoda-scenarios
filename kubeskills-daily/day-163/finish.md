## Lab Complete 🎉

**Verification:** Verify that the deployment shows all desired replicas as ready and available, that only one replica set is active with the correct revision, and that the rollout history reflects the action you took.

### What You Learned

A deployment rollout pauses when new pods fail readiness checks because maxUnavailable prevents removing old pods until new ones are ready
The rollout history command shows all previous revision numbers and their change causes
Rolling back using rollout undo immediately creates a new revision using the previous pod template
A maxSurge of zero combined with a failing readiness probe can fully block a rollout indefinitely
Checking events on the deployment and the failing pods together reveals the full picture of why a rollout stalled

### Why It Matters

Stuck rollouts are invisible to end users if old pods stay running but they create operational risk because the cluster is in a split state. If a node failure occurs during a stuck rollout, you may lose capacity from both the old and new replica set simultaneously because neither is fully healthy.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
