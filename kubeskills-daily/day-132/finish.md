## Lab Complete 🎉

**Verification:** Confirm that the frontend pod can successfully connect to the backend service on the correct port, and that pods from outside the payments namespace cannot reach the backend pod directly.

### What You Learned

Network Policies are additive and default-deny once applied to a pod
Both ingress and egress rules must be explicitly defined when isolation is needed
Pod selector labels must exactly match the target pod labels or traffic will be dropped
Missing namespace selectors can block cross-namespace communication silently
Always test Network Policies in staging before applying them to production workloads

### Why It Matters

In production, a misconfigured Network Policy can silently drop traffic between microservices, causing timeout errors that look like application bugs rather than network restrictions. Teams often spend hours debugging application logs before realizing the root cause is a missing ingress rule or a typo in a pod selector label.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
