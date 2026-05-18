## Lab Complete 🎉

**Verification:** Confirm that the etcd database size has decreased after defragmentation, that the etcd endpoint is reporting healthy status, and that the Kubernetes API server is still responding correctly to resource queries.

### What You Learned

etcd stores every revision of every object, and old revisions must be compacted to reclaim space
Defragmentation frees up fragmented disk space after compaction but requires brief unavailability
The etcd database has a configurable quota, and exceeding it puts etcd into a read-only alarm state
Monitoring etcd database size and revision count is a critical cluster health practice
Regular compaction jobs can be automated to prevent the database from growing unbounded

### Why It Matters

An etcd database that hits its storage quota will trigger an alarm that makes the entire Kubernetes API read-only, preventing any changes to the cluster. This means deployments, scaling, and configuration changes all stop working until the issue is resolved, turning a maintenance oversight into a production incident.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
