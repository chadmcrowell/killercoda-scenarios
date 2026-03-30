## Lab Complete 🎉

**Verification:** All pods from each corrected deployment are in Running state, each pod is scheduled on a node that satisfies the intended affinity rule, and describing the pods shows no scheduling warning events related to affinity.

### What You Learned

Required node affinity that matches no nodes leaves pods in Pending state indefinitely
Preferred node affinity is a soft rule and pods will schedule elsewhere if no match is found
Misspelled label keys or values silently cause affinity to have no effect
Operators like In, NotIn, Exists, and DoesNotExist must be chosen carefully to match your intent
Node affinity and nodeSelector can conflict and produce confusing scheduling outcomes

### Why It Matters

In production, incorrect node affinity rules can cause workloads to land on nodes with insufficient resources, wrong hardware, or in the wrong availability zone, leading to performance issues or outages. Operations teams have lost hours debugging why pods refuse to schedule when the answer was a single typo in a label value.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
