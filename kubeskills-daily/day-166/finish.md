## Lab Complete 🎉

**Verification:** Verify that the critical workloads now have resource requests set and are classified as Burstable or Guaranteed QoS, that the node conditions are being monitored, and that no critical pods appear in the evicted pod list after the changes are applied.

### What You Learned

The kubelet uses eviction thresholds defined as percentages or absolute values of available memory and disk space to trigger eviction
BestEffort pods with no resource requests or limits are evicted first followed by Burstable pods and then Guaranteed pods
Soft eviction thresholds give pods a grace period while hard eviction thresholds cause immediate termination
Node conditions like MemoryPressure and DiskPressure are set by the kubelet and prevent new pods from being scheduled
Setting proper resource requests is the most important thing you can do to protect a pod from premature eviction

### Why It Matters

Many teams deploy workloads without resource requests which makes them BestEffort class and the first to be killed during any node pressure event. A single memory-hungry deployment without limits can trigger a cascade where the node evicts unrelated critical workloads that happened to share the same node.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
