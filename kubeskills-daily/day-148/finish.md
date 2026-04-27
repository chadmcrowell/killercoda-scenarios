## Lab Complete 🎉

**Verification:** Confirm that each deployment now references a specific non-mutable image identifier, that rollback operations reference distinct and identifiable image versions, and that all pods in each deployment are running the exact same image digest.

### What You Learned

The latest tag is mutable by definition meaning the same tag can point to different image digests at different points in time
Kubernetes uses the image pull policy to decide whether to re-pull an image or use a cached version, which interacts badly with mutable tags
Using image digests instead of tags guarantees that every container runs exactly the same binary regardless of when or where it starts
Rollbacks with mutable tags may silently deploy a different image than the one originally in use at the rolled-back version
CI/CD pipelines should generate unique immutable tags per build such as a git commit SHA or build number

### Why It Matters

The latest tag is responsible for a class of production incidents that are notoriously difficult to diagnose because different pods may be running different code, making behavior inconsistent and logs misleading. In security-sensitive environments mutable tags also undermine image signing and verification workflows because a tag can be overwritten with a malicious image without any change to the deployment specification.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
