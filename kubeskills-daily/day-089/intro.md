# Day 89 — Node Affinity: Scheduling Where You Want

Three Deployments have been configured with node affinity rules. Two of them have pods stuck in Pending — the scheduler can't find any node that satisfies their constraints. The third is quietly running in the wrong place, and nobody noticed.

In this scenario you will:

- Deploy three workloads with different affinity configurations and observe the scheduling outcomes
- Learn the critical difference between `required` and `preferred` affinity rules
- Use `kubectl describe` and node label inspection to pinpoint why each pod is or isn't scheduling correctly
- Fix the broken Deployments by labeling nodes and correcting rules
- Build a combined required + preferred affinity spec to control scheduling with precision

Click **Start** to begin.