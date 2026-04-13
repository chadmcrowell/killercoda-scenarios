## Lab Complete 🎉

**Verification:** Confirm that all pods previously running on the drained node are now running on other nodes, that the drained node shows as unschedulable during maintenance and schedulable after uncordoning, and that no service experienced a reduction below its minimum available replicas during the process.

### What You Learned

Cordoning a node prevents new pods from being scheduled but does not move existing pods
Draining a node evicts all pods and requires PDB constraints to be satisfied before each eviction
Always check total cluster capacity before draining to ensure evicted pods have somewhere to land
DaemonSet pods are not evicted by a drain unless the ignore-daemonsets flag is used
After maintenance is complete the node must be uncordoned before the scheduler will place pods on it again

### Why It Matters

Node maintenance is one of the most common operational tasks in a Kubernetes environment and also one of the most common causes of self-inflicted outages. Skipping the capacity check before a drain, missing a critical PDB, or forgetting to uncordon a node after maintenance are all mistakes that have caused real production incidents for experienced engineers.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
