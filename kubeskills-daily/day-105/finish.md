## Lab Complete 🎉

**Verification:** The tainted node should have at least one pod from the target deployment running on it, the deployment should report all desired replicas as ready, and no scheduling failure events should appear for this deployment.

### What You Learned

A taint with the NoSchedule effect prevents new pods from landing on that node unless they carry a matching toleration
A taint with the NoExecute effect will also evict already running pods that do not tolerate it
Tolerations must match the taint key, value, and effect exactly for the scheduler to honor them
System components like kube-proxy and CoreDNS carry built-in tolerations for common node taints
Removing a taint from a node does not immediately reschedule pods that were blocked by it

### Why It Matters

Taints are widely used in production to dedicate nodes to specific workloads such as monitoring agents, GPU jobs, or control plane components. A missing toleration means your workload never reaches the intended node, and if that node was added specifically to handle extra capacity your entire scaling strategy fails silently.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
