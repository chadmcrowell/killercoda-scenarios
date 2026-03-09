## Lab Complete 🎉

**Verification:** All pods from the deployment should be in Running state and distributed across nodes that satisfy the corrected affinity rules. Scheduler events should no longer show any unschedulable warnings for the deployment.

### What You Learned

How required node affinity differs from preferred node affinity and when each should be used
How to read scheduler events to identify why a pod is not being placed on any node
How to inspect node labels to find mismatches between affinity rules and actual node configurations
How to fix affinity rules without restarting existing workloads unnecessarily
How preferred affinity acts as a soft hint while required affinity is a hard block

### Why It Matters

Node affinity is commonly used in production to place workloads on nodes with specific hardware such as GPUs or SSDs, and a misconfiguration means those workloads never run. In clusters with mixed node pools this kind of silent failure can halt entire deployment pipelines without any obvious error message.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
