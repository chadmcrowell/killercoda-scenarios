## Lab Complete 🎉

**Verification:** The monitoring pod must show a QoS class of Guaranteed in its status. When memory pressure is simulated, the eviction events on the node must show BestEffort and Burstable pods being evicted before the Guaranteed monitoring pod. The node MemoryPressure condition must resolve after the eviction cycle completes.

### What You Learned

Kubelet eviction thresholds are evaluated against actual node resource consumption not pod request and limit declarations
Soft eviction thresholds give pods a grace period while hard eviction thresholds cause immediate termination
Pods without resource requests are placed in the BestEffort QoS class and evicted first under pressure
Disk pressure eviction targets logs and image layers as well as emptyDir volumes used by pods
Eviction events appear in node conditions and can be monitored using node pressure taints

### Why It Matters

Node pressure eviction is a critical self-preservation mechanism but it can cause cascading failures when key infrastructure pods are evicted during a resource spike. Understanding eviction ordering and QoS classes allows you to protect critical workloads while still allowing the node to defend itself under genuine resource pressure.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
