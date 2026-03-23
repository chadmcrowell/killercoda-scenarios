## Lab Complete 🎉

**Verification:** Confirm all previously pending pods are now running on the correct tainted nodes and that no pods are being unexpectedly evicted due to NoExecute taint effects.

### What You Learned

A NoSchedule taint prevents any pod without a matching toleration from being scheduled on that node
A NoExecute taint evicts already running pods that do not have a matching toleration
The PreferNoSchedule taint effect is a soft preference and will still schedule pods if no other node is available
Tolerations must match the taint key, value, and effect exactly or the taint is not considered tolerated
System components like kube-proxy and CoreDNS use built-in tolerations to run on all nodes including tainted ones

### Why It Matters

Taints are widely used in production to dedicate nodes to specific workloads such as GPU nodes, spot instances, or nodes reserved for monitoring infrastructure. If you deploy a new workload to a cluster without understanding which nodes are tainted you will end up with all your pods pending on zero available nodes. The NoExecute effect is particularly dangerous because it can suddenly evict running pods from nodes when a new taint is applied during maintenance.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
