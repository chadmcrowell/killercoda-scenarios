## Lab Complete 🎉

**Verification:** Confirm the app-deployer ServiceAccount can create and update Deployments in the staging namespace but receives a Forbidden response when attempting to list secrets, access other namespaces, or perform any cluster-level operations. The original ClusterRoleBinding must no longer exist in the cluster.

### What You Learned

Wildcard verbs and resources in ClusterRoles grant permissions far beyond what most users realize
ClusterRoleBindings apply permissions across all namespaces while RoleBindings are namespace-scoped
The principle of least privilege must be enforced by auditing existing bindings regularly
Kubectl auth can-i is an essential tool for testing effective permissions from any subject perspective
Automatic aggregation labels on ClusterRoles can unexpectedly expand permissions if not understood

### Why It Matters

Accidental privilege escalation is one of the most common Kubernetes security misconfigurations found in production audits and penetration tests. A single developer or compromised pod with cluster-admin equivalent access can exfiltrate secrets, modify workloads, or destroy namespaces across the entire cluster.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
