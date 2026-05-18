# Pod Priority and Preemption - Workload Eviction in Action

Not all pods are created equal. Kubernetes allows you to assign priority values to pods using PriorityClass resources, which influence both scheduling order and preemption behavior. When the cluster runs out of capacity, the scheduler can evict lower-priority pods to place higher-priority ones. In this lab you will see this mechanism in action and learn how to design priority strategies that protect your most important workloads.

> **Day 168 of KubeSkills Daily** — Fail Fast, Learn Faster
