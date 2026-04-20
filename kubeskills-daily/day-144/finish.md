## Lab Complete 🎉

**Verification:** The audit log file should exist and contain entries. Filtering the log for delete verb on secrets should return the entry for your test deletion with the correct username and timestamp. The API server should be running normally with no TLS or startup errors.

### What You Learned

How Kubernetes audit log levels work and the difference between None, Metadata, Request, and RequestResponse
How to write an audit policy that captures secret access and deletion events without generating enormous log volume
Where audit logs are written and how to access them on a kubeadm-managed cluster
How to filter audit log entries by user, resource type, namespace, and verb to reconstruct an incident timeline
How to integrate audit logs with external log aggregation systems so they survive even if a node is compromised

### Why It Matters

After a security breach, audit logs are often the only way to determine whether a threat actor accessed sensitive data, which accounts were used, and what changes were made. Clusters without audit logging cannot satisfy compliance requirements for regulated industries and cannot produce the evidence needed for incident response.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
