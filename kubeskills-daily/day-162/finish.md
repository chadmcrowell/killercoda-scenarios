## Lab Complete 🎉

**Verification:** Confirm that all workloads in the namespace are running, that a pod violating the baseline profile is rejected by the admission controller, and that the namespace label shows enforce mode in the namespace metadata.

### What You Learned

Pod Security Admission uses three profiles: privileged, baseline, and restricted, each with increasing security requirements
The three enforcement modes are enforce which blocks pods, audit which logs violations, and warn which shows warnings to the user
Starting with warn or audit mode lets you discover violations before switching to enforce
The restricted profile requires pods to run as non-root and drop all capabilities which breaks many legacy workloads
Namespace labels control which profile and mode applies to that namespace

### Why It Matters

Jumping straight to enforce mode on the restricted profile without auditing first is one of the fastest ways to cause a production outage. Many popular open source tools and operators still ship containers that run as root and will be silently rejected until someone checks the admission controller logs.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
