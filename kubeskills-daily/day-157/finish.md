## Lab Complete 🎉

**Verification:** All manifests in the provided directory must apply successfully against the upgraded cluster without any API version errors. The deployed resources must be functional and show correct status. A scan of the manifest directory must return zero findings for deprecated or removed API versions.

### What You Learned

Kubernetes follows a deprecation policy where APIs are supported for at least one minor version after being deprecated
API removals are announced in release notes and can be detected using tools like pluto before upgrading
The API group and version together determine which fields and behaviors are available for a resource
Converted storage format in etcd does not automatically update living resources to new API versions
Helm chart API versions must be updated separately from the application manifests they manage

### Why It Matters

API deprecation failures during cluster upgrades are a major source of production outages and have blocked entire organizations from upgrading their clusters for months. Teams that continuously audit their manifest API versions and update them before reaching the removal version maintain the ability to upgrade safely and on schedule.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
