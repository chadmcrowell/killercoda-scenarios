## Lab Complete 🎉

**Verification:** Confirm that new pods can be scheduled and receive IP addresses, that the node IP allocation count is below the maximum, and that you can articulate the relationship between pod CIDR size and maximum schedulable pods per node.

### What You Learned

Each node in a Kubernetes cluster is allocated a subset of the pod CIDR and can only host as many pods as that node subnet allows
Terminated pods should have their IP addresses released but bugs in network plugins or node crashes can cause IP leak
The maximum pods per node setting in kubelet directly caps how many pod IPs a node can allocate regardless of resources
Choosing too small a pod CIDR at cluster creation time is a common source of IP exhaustion in growing clusters
Monitoring IP utilization per node should be part of cluster capacity planning alongside CPU and memory

### Why It Matters

Pod IP exhaustion causes a class of Pending pod failures that look deceptively like resource pressure but are actually a networking constraint, and operators who do not check IP allocation often waste time looking for CPU or memory headroom that would not help even if found. In production environments that run high-churn batch workloads or many short-lived pods, IP address management requires the same proactive planning as compute capacity.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
