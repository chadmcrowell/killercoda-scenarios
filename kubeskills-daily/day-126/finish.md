## Lab Complete 🎉

**Verification:** Confirm that the node no longer shows a DiskPressure condition, that the logging workload is running with proper ephemeral storage limits set, and that new pods can be successfully scheduled on the previously pressured node.

### What You Learned

Kubelet monitors disk usage against two thresholds called eviction-soft and eviction-hard, and once the hard threshold is breached pods are evicted immediately without a grace period
The DiskPressure node condition causes kubelet to apply a taint that prevents new pod scheduling on the affected node
Ephemeral storage limits on containers can prevent a single runaway workload from consuming all node disk space
Log rotation and container log size limits configured in the container runtime settings help prevent log-driven disk exhaustion
Checking node conditions with kubectl describe node and looking at events is the fastest way to confirm disk pressure is the root cause

### Why It Matters

Disk pressure events are notoriously silent until they start evicting your most critical workloads at the worst possible time. Production clusters that lack proper ephemeral storage limits and log rotation policies are one runaway container log away from cascading pod evictions. Understanding how kubelet eviction thresholds work and how to configure storage limits is tested in both CKA and CKAD exams.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
