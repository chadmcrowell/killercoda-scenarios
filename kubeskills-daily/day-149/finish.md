## Lab Complete 🎉

**Verification:** Confirm that pods can successfully resolve DNS and reach their permitted destinations, that attempts to connect to unauthorized external addresses are refused, and that the cloud instance metadata endpoint is unreachable from all pods in the namespace.

### What You Learned

Kubernetes network policies are additive meaning no policy means allow all, and the first policy applied begins restricting traffic
Egress policies control outbound connections from pods just as ingress policies control inbound connections
Allowing egress to the cluster DNS service is almost always required as a baseline or DNS resolution will break
Blockingegress to the cloud instance metadata service is a key defense against SSRF-based credential theft
Namespace selectors and IP block rules can be combined in egress policies to create layered outbound controls

### Why It Matters

Unrestricted pod egress is a significant security risk in production because a compromised or malicious container can exfiltrate data, reach command and control servers, or abuse cloud provider metadata APIs to steal instance credentials. Many compliance frameworks including SOC 2 and PCI DSS require demonstrable network segmentation controls that egress network policies directly satisfy.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
