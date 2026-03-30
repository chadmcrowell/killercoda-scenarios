## Lab Complete 🎉

**Verification:** All control plane certificates show expiration dates at least one year in the future, all control plane components are reporting healthy status, and the API server is accepting authenticated requests from kubectl without certificate errors.

### What You Learned

Kubernetes control plane certificates typically expire after one year unless cluster bootstrapping is configured otherwise
kubeadm provides certificate renewal commands that update all control plane certificates in the correct order
Etcd client certificates and API server serving certificates are separate and may have different expiration dates
Kubelet certificates can be configured for automatic rotation but control plane certificates often require manual renewal
After certificate renewal all control plane component pods must be restarted to pick up the new certificates

### Why It Matters

Certificate expiration is one of the few failure modes that can take an entire cluster completely offline in seconds, and because it happens on a predictable schedule it is entirely preventable with proper certificate monitoring and renewal automation. Organizations that did not implement certificate expiration alerting have experienced complete cluster outages that required hours of emergency recovery work.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
