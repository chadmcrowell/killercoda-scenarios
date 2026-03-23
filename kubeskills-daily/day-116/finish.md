## Lab Complete 🎉

**Verification:** Confirm that the web tier can reach the API tier, the API tier can reach the database, DNS resolution works for all pods, and the deny-all baseline policy is still in place preventing unauthorized traffic.

### What You Learned

A network policy that selects pods with an empty ingress rules list denies all inbound traffic to those pods
Network policies are additive meaning multiple policies combine to form the effective rule set
Pod selector labels in network policy rules must exactly match the labels on the target pods
DNS traffic on port 53 must be explicitly allowed if a deny-all policy covers the kube-system namespace or egress
Testing connectivity between pods using a utility container is the fastest way to validate policy changes

### Why It Matters

Network policies are a critical layer of defense in multi-tenant and compliance-driven environments, but they require careful implementation to avoid accidentally breaking legitimate traffic. The failure mode is silent because pods continue running and appear healthy but cannot communicate, causing timeouts and connection errors that look like application bugs rather than infrastructure policy failures. Teams often spend hours debugging application code before realizing a network policy change earlier in the day was the root cause.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
