## Lab Complete 🎉

**Verification:** Confirm that the PVC transitions from Pending to Bound status, that a PersistentVolume has been created and bound to the claim, and that the database pod transitions to Running state and can successfully write to the mounted volume.

### What You Learned

A PVC will remain in Pending state indefinitely if no StorageClass matching its request exists or if the provisioner cannot create a volume
The events on the PVC object contain detailed error messages from the provisioner that explain exactly why binding failed
StorageClass names are case sensitive and must match exactly between the PVC spec and the available storage classes
If no storageClassName is specified in a PVC, Kubernetes uses the default storage class if one is annotated
Annotating a StorageClass as the default using the storageclass.kubernetes.io annotation controls which class is used when none is specified

### Why It Matters

Stateful workloads like PostgreSQL, Kafka, and Elasticsearch all depend on PVCs binding successfully before their pods can start, meaning a StorageClass misconfiguration will silently block your entire data tier from coming online. In cloud environments, a deleted or renamed StorageClass after a cluster upgrade is a surprisingly common cause of production database outages that can take hours to diagnose without knowing where to look.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
