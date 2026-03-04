## Lab Complete 🎉

**Verification:** Confirm that the endpoints object for the service now contains pod IP addresses, that a test request to the service successfully reaches a pod, and that the service continues to route traffic as new pods are created by the deployment.

### What You Learned

A Kubernetes service routes traffic only to pods whose labels match every key-value pair in the service selector
A service with no matching pods will have an empty endpoints object, which you can inspect directly
Changing pod template labels in a deployment creates new pods with new labels but the old service selector will no longer match
Service selectors and pod labels are case sensitive and whitespace sensitive
Always verify endpoint population after creating or modifying a service to confirm traffic will actually route

### Why It Matters

Service selector mismatches are a leading cause of mysterious application outages after refactoring operations, label standardization projects, or copy-paste errors in manifests. In production this failure mode is especially dangerous because all components appear healthy in dashboards, the pods are running and ready, and the service exists, yet real user traffic is silently dropped with no obvious error.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
