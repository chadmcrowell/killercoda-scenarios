## Lab Complete 🎉

**Verification:** Confirm that the node transitions back to Ready status, that pod statuses on the node return to their correct Running or Completed states, that no new certificate authentication errors appear in the kubelet logs, and that the certificate expiration date has been extended.

### What You Learned

Kubelet uses a client certificate to authenticate to the API server, and when this certificate expires, the node will show as NotReady
Automatic certificate rotation must be enabled on both the kubelet and the controller manager to prevent expiration
Expired certificates on a node do not immediately kill running pods, but the control plane loses visibility into their health
The kubelet certificate is typically stored on the node filesystem and has a configurable rotation policy
Recovering from certificate expiration requires either enabling automatic rotation or manually renewing and distributing certificates

### Why It Matters

Certificate expiration is one of the most impactful cluster failures because it causes the control plane to lose contact with worker nodes, effectively making all workloads on affected nodes unmanageable even if they are technically still running. In production environments without automated certificate rotation, a cluster that was stood up and never maintained will reliably hit this failure at the one-year mark, often catching teams completely off guard.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
