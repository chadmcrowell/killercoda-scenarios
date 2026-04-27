## Lab Complete 🎉

**Verification:** Confirm that the node drain operation completes successfully, that pods are rescheduled to available nodes, and that the corrected PodDisruptionBudgets would still provide meaningful protection if a second node were to become unavailable simultaneously.

### What You Learned

A PDB with min available equal to the total number of replicas means zero pods can ever be disrupted voluntarily
Node drain operations respect PDBs by default and will hang indefinitely if the budget cannot be satisfied
Setting max unavailable to zero has the same blocking effect as setting min available to the replica count
Temporarily adjusting a PDB during planned maintenance is sometimes necessary but should be done with care and reverted promptly
Healthy PDB configuration requires knowing your deployment replica count and acceptable availability threshold simultaneously

### Why It Matters

In production environments PDB deadlocks are a common cause of failed cluster upgrades and emergency maintenance windows that run hours over schedule. An operator attempting to drain a node will see the operation hang with no clear error, and without understanding PDB interaction the temptation to force-delete pods creates availability gaps that the budget was designed to prevent in the first place.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
