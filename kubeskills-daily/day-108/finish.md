## Lab Complete 🎉

**Verification:** The updated pods should not contain a service account token volume mount, the applications should still be running and healthy, and a shell exec into the container should confirm the token file path no longer exists.

### What You Learned

The default service account in every namespace automatically mounts a token into pods unless explicitly disabled
Setting automountServiceAccountToken to false on the pod spec or service account removes the token from the container filesystem
Applications that do not call the Kubernetes API have no legitimate reason to have an API token mounted
A compromised pod with a mounted token can be used to escalate privileges if the service account has broad RBAC permissions
Minimizing token mounting is a key recommendation in the CKS exam and in real-world hardening guides

### Why It Matters

Token exposure is one of the most common entry points in Kubernetes security incidents because developers rarely think about disabling something that is on by default. An attacker who gains shell access to any pod with a mounted token can immediately begin probing the API server and potentially move laterally across the cluster if RBAC is not tightly scoped.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
