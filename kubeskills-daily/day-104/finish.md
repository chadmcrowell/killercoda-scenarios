## Lab Complete 🎉

**Verification:** All pods in the deployment should be in Running state, the node they are scheduled to should carry the label that matches the affinity rule, and no Pending events should appear in the scheduler output for this deployment.

### What You Learned

Required affinity rules are hard constraints and will keep pods Pending indefinitely if no matching node exists
Preferred affinity rules are soft hints and will not block scheduling if no match is found
The scheduler event log is the fastest way to diagnose affinity failures
Node labels must match exactly including case and any whitespace errors
Changing affinity rules on a running deployment requires a rollout to take effect on existing pods

### Why It Matters

In production, node affinity is commonly used to pin workloads to specific hardware tiers such as GPU nodes or high-memory instances. A misconfigured required affinity rule will silently starve your deployment of pods while users experience downtime, and the only visible signal is a flood of Pending pod events in the scheduler log.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
