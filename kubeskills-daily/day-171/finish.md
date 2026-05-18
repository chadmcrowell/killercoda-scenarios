## Lab Complete 🎉

**Verification:** Confirm that the cluster autoscaler logs show a successful scale-up decision, that the node group has added nodes, and that the previously pending pods have been scheduled and are now Running.

### What You Learned

The cluster autoscaler only adds nodes when pods are unschedulable due to resource constraints, not due to other scheduling failures
Node groups must have matching labels and taints to satisfy pending pod requirements or the autoscaler will not consider them
Scale-down is blocked when PodDisruptionBudgets would be violated or when pods cannot be rescheduled elsewhere
The autoscaler expander strategy controls which node group is selected when multiple groups could satisfy a pending pod
Cooling periods between scale-up and scale-down operations prevent flapping but can delay responses to sudden load drops

### Why It Matters

Engineering teams frequently enable the cluster autoscaler and assume it will handle all capacity challenges automatically. In reality, pods stuck due to affinity rules, taint mismatches, or resource requests that exceed the largest available instance type will never trigger autoscaling, leaving workloads in Pending indefinitely while operators investigate the wrong layer of the stack.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
