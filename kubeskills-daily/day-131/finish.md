## Lab Complete 🎉

**Verification:** Confirm that all nodes show the new target version in their status, that all control plane component pods are running at the new version, that the previously deprecated API resources are now using supported API versions, and that all application workloads are running normally after the upgrade.

### What You Learned

Kubernetes only supports upgrading one minor version at a time, meaning you cannot jump from version 1.26 directly to 1.28 without passing through 1.27
The control plane must always be upgraded before worker nodes because the API server must be at the same or higher version than the kubelet
Workloads using deprecated API versions that have been removed in the target version will fail to apply after the upgrade, so you must migrate manifests before upgrading
Kubeadm upgrade plan shows you what the upgrade will do and flags any compatibility issues before you commit to the upgrade
Draining a node before upgrading it ensures no running workloads are disrupted when kubelet is stopped and updated during the upgrade process

### Why It Matters

A failed cluster upgrade can leave your control plane partially upgraded and unable to accept certain API requests, creating a situation that is extremely difficult to recover from without a full etcd restore. Production organizations that skip pre-upgrade API deprecation checks routinely discover broken deployments and broken CI pipelines the morning after a version bump. The CKA exam includes cluster upgrade tasks as a core competency that every candidate must be able to execute correctly.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
