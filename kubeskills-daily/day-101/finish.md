## Lab Complete 🎉

**Verification:** You should be able to identify the exact user or service account that deleted the namespace, the timestamp of the deletion, and at least two preceding API calls made by the same identity. You should also be able to explain one gap in the current audit policy that should be addressed.

### What You Learned

How audit log policies control which API requests are recorded and at what level of detail
How to filter audit logs by verb, resource type, and user identity to find specific events quickly
How service account tokens, user certificates, and OIDC identities appear in audit log records
How to reconstruct a sequence of changes from audit logs to understand the full context of an incident
How to configure audit policies that capture security-relevant events without overwhelming log storage

### Why It Matters

Without audit logging enabled and properly configured, a Kubernetes cluster is essentially a black box where destructive changes leave no forensic trail. Regulatory frameworks including SOC2, PCI-DSS, and HIPAA require audit trails for privileged operations, and missing logs during an incident can make root cause analysis impossible.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
