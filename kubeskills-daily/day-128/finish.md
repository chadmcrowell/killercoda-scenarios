## Lab Complete 🎉

**Verification:** Confirm that the etcd pod is running and healthy, that all workloads that were deleted during the simulated disaster are visible and in a running state, and that new deployments can be created successfully confirming the cluster is fully operational after the restore.

### What You Learned

The etcdctl snapshot save command creates a point-in-time backup of all cluster state and requires the etcd endpoint, CA certificate, client certificate, and client key to authenticate
Snapshot restore does not directly restore to a running cluster but instead creates a new data directory that etcd must be restarted to use
After a restore you must update the etcd static pod manifest to point to the new data directory and wait for the static pod to restart
Always verify a snapshot with etcdctl snapshot status before relying on it for disaster recovery
In a multi-node etcd cluster all members must be stopped and restored from the same snapshot to avoid split-brain scenarios

### Why It Matters

The CKA exam has included an etcd backup and restore task in nearly every sitting, and failing to complete it correctly costs significant points. In production, organizations that do not regularly test their etcd restore procedures often discover their backups are invalid or their team does not know the restore process only after a real disaster has already occurred. This is a non-negotiable operational skill for anyone managing Kubernetes clusters.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
