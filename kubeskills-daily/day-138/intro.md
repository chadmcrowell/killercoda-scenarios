# Node Drain and Cordon - Maintenance Without Chaos

A node in the production cluster requires a kernel update. Before the operations team can apply the update they need to safely remove all workloads from the node. You have been asked to perform the maintenance workflow safely, ensuring no service disruption occurs and that all pods are successfully rescheduled before the node is taken offline.

> **Day 138 of KubeSkills Daily** — Fail Fast, Learn Faster
