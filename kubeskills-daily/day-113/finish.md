## Lab Complete 🎉

**Verification:** Confirm that critical pods now show Guaranteed QoS class, that non-critical pods retain lower QoS classes, and that the overall resource configuration reflects intentional eviction priority ordering.

### What You Learned

Pods without any resource requests or limits are classified as BestEffort and are evicted first
Pods with mismatched requests and limits fall into the Burstable class and are next in line
Pods where requests exactly equal limits receive Guaranteed status and are last to be evicted
The kubelet eviction threshold determines when eviction begins not when the node is completely full
Setting resource requests on all production pods is the minimum bar for protecting against unexpected eviction

### Why It Matters

In a production cluster under memory pressure the kubelet makes eviction decisions in seconds, and if your critical API server pods have no resource requests they will be treated as expendable. This means a noisy neighbor workload with no limits can indirectly cause your customer-facing services to be evicted before the offending pod. Engineers who skip resource configuration during initial deployments often discover this lesson for the first time during a production incident.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
