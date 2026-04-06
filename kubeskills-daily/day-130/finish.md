## Lab Complete 🎉

**Verification:** Confirm that the PV with the Retain policy was successfully reclaimed and rebound to a new PVC, that the new StorageClass has the correct reclaim policy configured, and that deleting the StatefulSet left its PVCs in a Released state with data intact rather than deleting them.

### What You Learned

The Delete reclaim policy causes the underlying storage asset to be deleted along with the PV when the PVC is deleted, which means data is gone permanently with no recovery option
The Retain policy keeps the PV and its data after PVC deletion but leaves the volume in a Released state that prevents automatic rebinding until an administrator manually reclaims it
The Recycle policy is deprecated and should not be used in modern clusters as it simply performs a basic scrub of the volume data before making it available again
Dynamically provisioned volumes created by a StorageClass inherit the reclaim policy configured in the StorageClass definition
To reuse a Retained PV you must manually edit it to remove the claimRef that binds it to the deleted PVC before a new PVC can bind to it

### Why It Matters

Production data loss events caused by accidental PVC deletion with the Delete reclaim policy are more common than anyone wants to admit, and they have ended careers. Understanding reclaim policies is especially critical when working with stateful workloads like databases and message queues where the data outlives the application lifecycle. Both CKA and CKAD exams include storage scenarios that test your understanding of PV and PVC lifecycle management.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
