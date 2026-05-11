## Lab Complete 🎉

**Verification:** Confirm that DNS lookups succeed from inside the application pod, that the application health check returns healthy, and that the deny-all egress policy is still in place alongside the new DNS allow rule.

### What You Learned

A deny-all egress policy blocks port 53 UDP and TCP traffic to CoreDNS which breaks all DNS resolution in the namespace
CoreDNS pods run in the kube-system namespace and listen on port 53 which requires an explicit egress rule to reach them
Network policies are additive so you do not need to remove the deny-all policy, you just add a permitting rule
Testing DNS from inside a pod using nslookup or dig is the fastest way to confirm whether DNS is the problem
Always test network policies in a non-production namespace first before applying them to running workloads

### Why It Matters

DNS failures caused by overly aggressive network policies are one of the most common and frustrating misconfiguration patterns in Kubernetes. Because the symptoms look like application connectivity issues rather than infrastructure issues, engineers waste significant time debugging the application before checking the network layer.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
