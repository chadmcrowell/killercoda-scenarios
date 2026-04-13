## Lab Complete 🎉

**Verification:** Confirm that the service account can read ConfigMaps and list pods in its own namespace but cannot list secrets or access resources in other namespaces.

### What You Learned

ClusterRoleBindings apply permissions across the entire cluster, not just one namespace
Wildcard verbs and resources should never be used in production roles
Service account tokens are automatically mounted in pods and can be used to call the API server
Least privilege means granting only the exact verbs and resources a workload actually needs
Regularly audit RoleBindings and ClusterRoleBindings using built-in RBAC review commands

### Why It Matters

In a real breach scenario, an attacker who compromises a pod with an overly permissive service account can list secrets, create new pods with privileged access, or even take over the entire cluster. RBAC misconfigurations are consistently listed in Kubernetes security audits as the number one path to cluster compromise.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
