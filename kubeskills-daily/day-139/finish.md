## Lab Complete 🎉

**Verification:** The pod should be in Running state, scheduler events should show successful node selection, and describing the pod should show a valid node assignment with no unresolved constraint warnings.

### What You Learned

How to read scheduler events to understand exactly why a pod cannot be placed
The difference between NodeSelector hard constraints and NodeAffinity preferred constraints
How resource fragmentation across nodes can block scheduling even when total cluster capacity looks sufficient
How to use kubectl describe pod to extract actionable scheduling failure messages
Why combining multiple constraints multiplies the chance of scheduling deadlock

### Why It Matters

In production, a misconfigured NodeSelector can silently block an entire deployment rollout while your on-call team scrambles to understand why pods stay Pending. Getting scheduling constraints wrong during peak traffic events can mean zero new replicas come online precisely when you need them most.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
