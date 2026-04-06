## Lab Complete 🎉

**Verification:** Confirm that the ClusterRoleBinding no longer exists, that a properly scoped RoleBinding exists in the development namespace, and that auth can-i checks confirm the app-runner service account cannot delete secrets cluster-wide but can still get pods within the development namespace.

### What You Learned

ClusterRoleBindings grant permissions across every namespace in the cluster, not just the one where they are created
Binding a service account to cluster-admin violates the principle of least privilege and is a critical security finding
Kubectl auth can-i with impersonation flags lets you verify what any service account can actually do
Namespace-scoped RoleBindings should always be preferred over ClusterRoleBindings when access is only needed in one namespace
Regular RBAC audits using tools like kubectl-who-can or rbac-lookup can surface accidental privilege escalation before attackers do

### Why It Matters

In production, overly permissive service accounts are one of the most common paths for lateral movement after a container escape or compromised pod. A single developer mistake creating a ClusterRoleBinding instead of a RoleBinding can expose your entire cluster's secrets, config maps, and workloads to any process running under that service account. CKS candidates are expected to identify and fix exactly these kinds of misconfigurations under exam pressure.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
