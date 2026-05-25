## Lab Complete 🎉

**Verification:** Confirm that DNS resolution from pods in the target namespace succeeds after the CoreDNS egress exception is added, that the application can connect to the authorized upstream gateway IP and port, that attempts to connect to any other external address are rejected with a connection timeout, and that the Network Policy is listed with both deny-all and exception rules visible.

### What You Learned

A Network Policy that selects pods and defines only ingress rules does not restrict egress traffic from those same pods
To restrict all egress you must explicitly create a policy with an empty egress array which blocks all outbound connections
DNS traffic to CoreDNS must be explicitly allowed in egress rules or your pods will lose the ability to resolve names
Egress exceptions should be as specific as possible including both the destination CIDR and port
Not all CNI plugins fully support egress Network Policy enforcement so verify your CNI capabilities first

### Why It Matters

A pod that is compromised through an application vulnerability but lives in a namespace with only ingress policies is completely free to exfiltrate your data to any external IP address. This gap between what teams think network policies provide and what they actually enforce is one of the most common security findings in Kubernetes environment assessments.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
