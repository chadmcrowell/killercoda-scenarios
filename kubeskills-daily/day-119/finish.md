## Lab Complete 🎉

**Verification:** All desired replicas are in Running state, no pods remain in Pending with scheduling-related events, and describing the pods shows they are distributed across available nodes without anti-affinity violations.

### What You Learned

Required pod anti-affinity with topology key set to hostname means each pod must land on a unique node
If replica count exceeds available nodes, the extra pods will remain Pending forever
Preferred anti-affinity allows spread without hard blocking when nodes are scarce
The topologyKey field controls the domain of anti-affinity enforcement and must match real node labels
Switching from required to preferred anti-affinity is often the right tradeoff in smaller clusters

### Why It Matters

Teams running high availability workloads with required anti-affinity have been caught off guard when a node failure reduces capacity and prevents a deployment rollout from completing, leaving the cluster in a partial update state. Understanding when required anti-affinity creates a ceiling on scalability is critical for capacity planning.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
