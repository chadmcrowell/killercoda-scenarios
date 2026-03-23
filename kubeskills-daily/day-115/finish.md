## Lab Complete 🎉

**Verification:** Verify that the application pod logs no longer show 403 errors, that the pod can successfully list and watch pods in its namespace, and that the role binding correctly references both the role and the service account.

### What You Learned

Every pod uses a service account token to authenticate to the Kubernetes API server
A pod assigned a service account with no role bindings will receive 403 errors for any API call
Roles define what API groups, resources, and verbs are permitted within a namespace
RoleBindings connect a role to a service account, user, or group
ClusterRoles and ClusterRoleBindings are needed when access spans multiple namespaces or cluster-level resources

### Why It Matters

Operators, controllers, and many cloud-native tools like service meshes and monitoring agents require specific API permissions to function correctly. When these permissions are absent the application may start successfully but fail silently or crash loop as it retries failed API calls. In production this often manifests as an operator that appears healthy but is not actually reconciling any resources, causing configuration drift that is discovered only during an incident.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
