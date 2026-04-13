## Lab Complete 🎉

**Verification:** Confirm that all pods in the namespace have resource requests and limits defined, that they are assigned the Burstable or Guaranteed QoS class, and that the LimitRange rejects any new pod definition that omits resource requests.

### What You Learned

Pods without resource requests are assigned the BestEffort QoS class and are evicted first under memory pressure
The scheduler uses resource requests, not actual usage, to make placement decisions
Nodes can become overcommitted when many BestEffort pods land on the same node
Setting requests equal to typical usage and limits at peak usage is a common baseline strategy
LimitRange objects can enforce minimum request values across an entire namespace

### Why It Matters

In production, a single high-traffic service without resource requests can consume an entire node's CPU, causing latency spikes for every other workload sharing that node. The problem is often invisible until a traffic event occurs because normal monitoring shows plenty of available capacity right up until the moment everything degrades at once.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
