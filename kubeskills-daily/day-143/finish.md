## Lab Complete 🎉

**Verification:** All certificates should show updated expiration dates extending well beyond the current date. All control plane components should be running normally and kubectl commands against the cluster should succeed without TLS errors.

### What You Learned

How to use kubeadm certs check-expiration to see all certificate expiry dates in a single view
Which certificates are managed automatically by kubeadm renewal versus which require manual intervention
How to renew all cluster certificates at once and what services need to be restarted afterward
How kubelet client certificates differ from static pod certificates in terms of auto-rotation behavior
How to set up monitoring alerts on certificate expiration so you are never surprised by an expiry

### Why It Matters

When API server certificates expire, every kubectl command fails, every controller stops reconciling, and the cluster becomes completely unmanageable. Restoring connectivity requires manual intervention on the control plane nodes and cannot be done remotely, making this one of the most operationally painful failures a team can experience.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
