## Lab Complete 🎉

**Verification:** Verify the node drain completes successfully, the rolling update finishes without errors, and the PDB still provides meaningful protection by allowing at least one pod to remain available during disruptions.

### What You Learned

A PDB with minAvailable equal to the total number of replicas prevents any voluntary eviction
Node drain operations respect PDBs and will block indefinitely rather than violate them
Rolling updates can stall if the PDB does not allow even one pod to be unavailable
The kubectl drain command reports which PDB is blocking eviction in its output
Adjusting minAvailable or maxUnavailable in the PDB is required before drain can proceed

### Why It Matters

During cluster upgrades or node maintenance you need to drain nodes safely, and a poorly configured PDB will halt that process entirely. In a real incident this means a node with a hardware failure cannot be cordoned and drained without first correcting the PDB, leaving your cluster in a degraded state longer than necessary. Teams that set PDBs to protect every single pod replica without understanding the mathematics often discover this during their first cluster upgrade.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
