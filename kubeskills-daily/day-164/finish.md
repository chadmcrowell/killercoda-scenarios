## Lab Complete 🎉

**Verification:** Confirm that the PVC status shows the new requested capacity, that the filesystem visible inside the pod reflects the expanded size, and that all application data written before the resize is still intact.

### What You Learned

Volume expansion requires the storage class to have allowVolumeExpansion set to true otherwise the API server rejects the resize request
After editing the PVC requested storage, the PVC enters a Resizing condition and then a FileSystemResizePending condition
For online expansion with supported CSI drivers the filesystem is resized automatically while the pod keeps running
For drivers without online expansion support the pod must be restarted to trigger the filesystem resize
The PVC status capacity field only updates to the new size after the filesystem resize is completed not when you edit the spec

### Why It Matters

Teams often panic when they see the PVC spec shows the new size but the application still reports being out of space. The filesystem inside the container is still the old size and the pod needs to be restarted to complete the resize, which means the application will experience a brief interruption even on clusters with online expansion theoretically supported.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
