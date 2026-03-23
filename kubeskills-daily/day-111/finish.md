## Lab Complete 🎉

**Verification:** Confirm that all previously pending pods are now in the running state and that the scheduler events no longer show any affinity-related warnings or errors.

### What You Learned

Required node affinity rules cause pods to stay pending indefinitely if no matching node exists
Preferred affinity rules allow pods to schedule on any node if no match is found
Node labels must exactly match the affinity selector including case sensitivity
The scheduler events on a pod describe command reveal why affinity rules are failing
Removing or relaxing required rules is often the fastest path to unblocking pending pods

### Why It Matters

In production environments node affinity is commonly used to pin workloads to specific hardware tiers such as GPU nodes or high-memory nodes. A misconfigured required affinity rule means your application never starts, and if you are relying on this for a critical batch job or latency-sensitive service the business impact can be severe. Many on-call engineers waste hours chasing resource limits or image issues when the real problem is a label mismatch on a single character.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
