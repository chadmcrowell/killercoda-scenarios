## Lab Complete 🎉

**Verification:** Confirm that the etcd database size is significantly reduced from its pre-compaction value, that no storage quota alarm is active when you query the alarm list, and that write operations to the Kubernetes API server complete successfully without any database space exceeded errors.

### What You Learned

etcd keeps historical revisions of every key until you explicitly compact them away
Compaction removes old revisions but does not free disk space until defragmentation is also performed
The default etcd storage quota is 2GB and clusters hitting this limit receive a database space exceeded alarm
Once the alarm fires the API server enters a read-only state until the alarm is cleared
Regular compaction and defragmentation should be part of your cluster maintenance schedule

### Why It Matters

A cluster with an unresponsive API server is completely unmanageable, and etcd storage exhaustion is one of the most common root causes of this in long-running clusters. Missing this maintenance task means your team cannot deploy, scale, or modify any workload until the issue is resolved, often during an incident rather than planned maintenance.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
