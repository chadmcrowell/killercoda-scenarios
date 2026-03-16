## Lab Complete 🎉

**Verification:** The node should reach a cordoned and drained state with no running pods remaining on it, the deployment should have all its remaining pods running and healthy on other nodes, and the drain command should exit without a disruption budget error.

### What You Learned

A pod disruption budget with minAvailable equal to the replica count means no pod can ever be voluntarily disrupted
Node drain is a voluntary disruption and will be blocked by a PDB that cannot be satisfied
The drain command will print a warning showing which PDB is blocking the eviction
Reducing minAvailable or increasing replicas before draining is the correct remediation approach
Force draining bypasses PDBs entirely and should only be used in emergencies with full awareness of the risk

### Why It Matters

Node drains are a normal part of Kubernetes cluster maintenance including node upgrades and hardware replacement. If a PDB is too restrictive it can block automated upgrade tooling for hours and delay critical security patches, turning routine maintenance windows into multi-hour incidents.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
