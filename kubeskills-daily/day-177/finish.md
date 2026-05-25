## Lab Complete 🎉

**Verification:** Confirm that the scheduler events show preemption occurring only against the lowest-priority pods, that the critical-priority pod reaches the Running state, that the evicted lower-priority pods are eventually rescheduled once capacity is available, and that no production-tier pods were evicted during the preemption sequence.

### What You Learned

PriorityClass objects define numeric priority values that the scheduler uses to rank pods when making preemption decisions
Pods without an explicit PriorityClass receive a default priority of zero unless a default PriorityClass is configured
Preemption evicts lower-priority pods only on nodes where doing so would allow the high-priority pod to be scheduled
Evicted pods are not permanently deleted and will be rescheduled if capacity becomes available elsewhere
System-level PriorityClasses like system-cluster-critical and system-node-critical should never be used for application workloads

### Why It Matters

Without a deliberate priority strategy, any developer with permission to create a PriorityClass can deploy a workload that preempts your most critical production services. Organizations that discover this capability during an incident rather than during planning often face extended outages while they untangle which pods evicted which and why their PodDisruptionBudgets did not protect them.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
