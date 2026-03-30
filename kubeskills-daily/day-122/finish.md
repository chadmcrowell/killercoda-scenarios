## Lab Complete 🎉

**Verification:** The pod has been running continuously without eviction events, the node event log no longer shows ephemeral storage exceeded messages for this workload, and the pod description shows the corrected ephemeral storage configuration.

### What You Learned

Ephemeral storage limits cover container writable layers, emptyDir volumes, and container log files
Exceeding the ephemeral storage limit causes kubelet to evict the pod with an eviction rather than a container restart
Eviction events appear on the node and in pod events but not as a container termination reason
Using a dedicated volume instead of the container writable layer prevents ephemeral storage violations
Log rotation and size limits on container logging agents help prevent log files from consuming ephemeral storage

### Why It Matters

Ephemeral storage evictions are particularly painful in production because they are often discovered only after an alert fires on pod availability, and the eviction reason is buried in node events that most teams do not monitor by default. Applications that write cache data or temporary files to the container filesystem are especially vulnerable when ephemeral storage limits are set too conservatively.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
