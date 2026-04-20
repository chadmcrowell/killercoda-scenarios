## Lab Complete 🎉

**Verification:** Cross-namespace connections between tenant services should now be refused. Resource quota objects should be in place for both namespaces and attempts to exceed limits should result in quota exceeded errors. DNS resolution should still work for pods within each namespace.

### What You Learned

Why namespaces alone do not prevent cross-namespace network communication without network policies
How to layer resource quotas and limit ranges to prevent one tenant from consuming all cluster resources
The risks of allowing pods to use host networking or host PID which bypass namespace isolation entirely
How to use network policies to enforce a default deny posture and then selectively allow required traffic
Why cluster-scoped resources like ClusterRoles and PersistentVolumes are visible across all namespaces regardless of RBAC namespace scoping

### Why It Matters

In shared clusters, a noisy or malicious tenant can exhaust resources that affect all other tenants, access services they should not be able to reach, and potentially exfiltrate data if network isolation is not enforced. Multi-tenancy failures have led to real data breaches in shared Kubernetes environments.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
