## Lab Complete 🎉

**Verification:** New nodes should appear in the cluster in a Ready state, the previously Pending pods should be scheduled and running on the new nodes, and the autoscaler log should contain a scale-up event message referencing the deployment as the trigger.

### What You Learned

The cluster autoscaler only triggers scale-up for pods that are Pending due to insufficient resources, not for pods that are Pending for other reasons like affinity failures
Pods without resource requests defined will appear to fit on any node and the autoscaler will not scale up for them
The cluster.autoscaler.kubernetes.io/safe-to-evict annotation can block scale-down but annotation misuse can also interfere with autoscaler logic
Node group minimum and maximum bounds in the autoscaler configuration cap how many nodes can be added
The autoscaler logs are the primary diagnostic tool and clearly report why scale-up was or was not triggered

### Why It Matters

Cluster autoscaler failures under load mean your application cannot scale out to meet demand even though you have configured autoscaling and believe it is working. This is especially dangerous during traffic spikes when every second of under-provisioning translates directly to user-facing latency or error rates, and the fact that the autoscaler appears healthy makes the failure very hard to notice.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
