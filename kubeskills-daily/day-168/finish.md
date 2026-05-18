## Lab Complete 🎉

**Verification:** Confirm that the high-priority pod is Running on the node, that preemption events are visible in the pod event history, and that the evicted low-priority pods have been terminated to free up resources.

### What You Learned

PriorityClass objects define integer priority values that the scheduler uses to rank pods
When a high-priority pod cannot be scheduled, the scheduler looks for nodes where evicting lower-priority pods would free enough resources
Preemption removes lower-priority pods gracefully, respecting termination grace periods
System-critical and cluster-critical priority classes are reserved for essential Kubernetes components
PodDisruptionBudgets do not protect pods from preemption, only from voluntary disruptions

### Why It Matters

Teams that do not define priority classes for their workloads often discover that batch jobs or development deployments can inadvertently consume resources that production services need. When a critical workload cannot schedule, preemption may cause unexpected pod evictions that look like mysterious disappearances in your logs.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
