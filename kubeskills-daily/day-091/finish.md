## Lab Complete 🎉

**Verification:** Verify that all pods in the deployment transition from Pending to Running state, that the scheduling events no longer show FailedScheduling errors, and that the correct node is hosting the workload as intended.

### What You Learned

The scheduler will leave a pod in Pending state indefinitely if no node satisfies its node selector requirements
Describing a pending pod reveals FailedScheduling events that explain exactly which constraint could not be satisfied
Node selectors are exact string matches and are case sensitive, so even a single character difference will cause failure
Node affinity rules offer more expressive scheduling constraints than simple node selectors
Adding missing labels to nodes is one valid fix, but changing the pod spec to match existing labels is often safer in production

### Why It Matters

In production environments, node selectors are commonly used to direct workloads to specific hardware such as GPU nodes or high-memory nodes, and a misconfiguration can silently block deployments for hours or days without anyone noticing if alerting is not configured. Missing this failure mode during a cluster migration or hardware refresh can cause entire application tiers to go dark while the pods quietly sit in Pending state.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
