## Lab Complete 🎉

**Verification:** Confirm that all three pods no longer appear in any namespace even with the show-all flag, that no orphaned finalizers remain on any resources in the affected namespaces, and that the StatefulSet rolling update completes successfully after the stuck pods are resolved.

### What You Learned

Finalizers are strings stored in an object's metadata that prevent deletion until a controller removes them, so if the controller is gone the pod stays stuck forever
Force deleting a pod with grace period zero bypasses the graceful shutdown and should only be used when you understand the consequences for stateful workloads
A pod stuck in Terminating on a NotReady node will stay there until the node recovers or you force delete it, because only that node's kubelet can clean up the pod
PreStop hooks that hang or fail will block pod termination up to the terminationGracePeriodSeconds timeout before the container is forcibly killed
Patching the finalizers array to empty on a stuck object is the correct way to unblock deletion when the responsible controller no longer exists

### Why It Matters

Stuck terminating pods are a real operational hazard that blocks namespace deletion, confuses service endpoints, and causes StatefulSet rolling updates to freeze. In production, not understanding finalizers and how to safely remove them can lead to hours of downtime as teams try random force delete commands without understanding the downstream consequences. CKA exams frequently include scenarios where you must clean up stuck resources by manipulating finalizers.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
