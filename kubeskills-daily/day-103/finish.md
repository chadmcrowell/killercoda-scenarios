## Lab Complete 🎉

**Verification:** All nodes in the cluster should be running kubelet versions within the supported skew range of the API server version. Workloads scheduled to the previously outdated nodes should now use all API features successfully without errors.

### What You Learned

How Kubernetes version skew policy defines the maximum supported version difference between control plane and node components
How to check the version of every component in the cluster including API server, kubelet, and kube-proxy
How version skew manifests as failures of newer API features on older nodes while basic scheduling continues to work
How to safely drain and upgrade individual nodes without disrupting workloads running on compliant nodes
How to use version information to determine upgrade ordering and avoid creating skew during multi-step upgrades

### Why It Matters

Partial cluster upgrades are extremely common in practice because teams upgrade control planes first and then discover nodes lagging behind, and the resulting version skew problems are notoriously hard to diagnose because symptoms appear in unrelated features. Following the correct upgrade sequence and verifying component versions after each step prevents hours of confusing troubleshooting.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
