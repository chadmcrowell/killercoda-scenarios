## Lab Complete 🎉

**Verification:** Confirm that each workload can still perform its intended function, that no service account retains access to resources it does not need, and that attempting to perform an unauthorized action from within a pod returns a permission denied error.

### What You Learned

Service accounts are identities that pods use to authenticate to the API server
The default service account in each namespace has no special permissions by default but can be bound to powerful roles
Auditing role bindings regularly helps catch privilege creep before it becomes a security incident
Using dedicated service accounts per workload limits the blast radius of a compromised pod
Binding the minimum required verbs and resources to a role is the safest long-term pattern

### Why It Matters

Over-permissioned service accounts are one of the most common attack vectors in Kubernetes environments because a compromised pod can use its token to access or modify cluster resources at a scale the operator never intended. In production, unreviewed role bindings accumulate over time and create silent privilege escalation paths that are difficult to detect without dedicated auditing tooling.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
