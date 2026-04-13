## Lab Complete 🎉

**Verification:** Confirm that the autoscaler logs no longer show the PDB as a blocker for the affected nodes and that the deployment still has sufficient replicas running to meet its availability requirements after the configuration change.

### What You Learned

The cluster autoscaler only scales down nodes when it can safely evict all pods within PDB constraints
A PDB with maxUnavailable set to zero on a single-replica deployment permanently blocks node drain
Setting minAvailable to less than the total replica count gives the autoscaler room to evict pods
The autoscaler logs will show exactly which PDB is blocking a scale-down event
PDB and autoscaler configurations must be designed together not independently

### Why It Matters

Nodes that cannot scale down because of overly strict PDBs translate directly into unnecessary cloud costs that accumulate continuously. In large clusters this can mean dozens of underutilized nodes running indefinitely while the finance team wonders why the Kubernetes bill keeps climbing despite low application traffic.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
