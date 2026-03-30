## Lab Complete 🎉

**Verification:** All StatefulSet replicas are in Running state, all corresponding PVCs show a status of Bound, and the pod events no longer contain warnings about unbound persistent volume claims.

### What You Learned

StatefulSet pods will not start until their corresponding PVC is successfully bound to a persistent volume
PVCs remain in Pending state when no available PV matches the requested storage class, access mode, or capacity
VolumeClaimTemplates in a StatefulSet create one PVC per replica and these are not deleted when the StatefulSet is scaled down
A StorageClass with a non-existent or misconfigured provisioner will cause all PVCs referencing it to stay Pending indefinitely
Deleting a stuck PVC allows the StatefulSet controller to recreate it, which can resolve transient provisioning failures

### Why It Matters

StatefulSet PVC binding failures block database deployments, message queue clusters, and other stateful workloads from initializing at all, and in some cases the failure is not obvious because the StatefulSet appears to be progressing while individual replicas are silently stuck. In multi-replica StatefulSets, a PVC binding failure on a single replica can block the entire rolling update from completing.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
