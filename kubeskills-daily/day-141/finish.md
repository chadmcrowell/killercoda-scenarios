## Lab Complete 🎉

**Verification:** Auth can-i checks for the service accounts should return denied for operations they should not have. Application pods should remain healthy and logs should show no permission denied errors for legitimate operations.

### What You Learned

How to enumerate all ClusterRoleBindings and RoleBindings to identify overly permissive assignments
Why wildcard verbs and resource names in Role definitions are dangerous even when scoped to a single namespace
How to use auth can-i checks to verify what a specific service account is actually allowed to do
The difference between ClusterRole and Role and why binding a ClusterRole at namespace scope still grants significant power
How to write minimal Roles that grant only the exact verbs and resources an application actually needs

### Why It Matters

A compromised pod running with an over-permissive service account can read secrets across the entire cluster, delete workloads, or even create new pods with elevated privileges. In regulated industries, failing to demonstrate least-privilege RBAC is a compliance violation that can trigger audit findings.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
