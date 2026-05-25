## Lab Complete 🎉

**Verification:** Confirm that the number of ReplicaSet objects with zero replicas has decreased to match the new revision history limit, that completed Job pods are no longer present for Jobs that exceeded the TTL window, that the PersistentVolumeClaims in unhealthy states have been removed, and that the total object count in etcd has measurably decreased.

### What You Learned

Owner references link child objects to their parent so the garbage collector can clean them up automatically when the parent is deleted
Completed Job pods and old ReplicaSet revisions are not deleted by default unless TTL or revision history limits are configured
The TTL controller can automatically delete finished Job objects after a configurable time-to-live period
Deployment revision history is controlled by the revisionHistoryLimit field which defaults to ten
Orphaned resources consume etcd storage, API server memory, and can slow down list operations used by controllers

### Why It Matters

A cluster that has never been cleaned up will eventually exhibit degraded controller performance and slow API response times even if node capacity appears healthy. Operations teams that inherit a long-running cluster often encounter thousands of stale objects that make it difficult to find current resources and can mask real problems during incidents.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
