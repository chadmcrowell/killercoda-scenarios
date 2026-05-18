# Cluster Autoscaler Failures - Diagnosing Scaling Blockages

The cluster autoscaler promises elastic capacity for your Kubernetes workloads, but it has specific requirements that must be met before it will act. Pods must be unschedulable for resource reasons, node groups must be compatible with pending pod requirements, and scale-down must not violate disruption budgets. In this lab you will work through a real scenario where autoscaling appears broken and systematically identify and resolve each blocking condition.

> **Day 171 of KubeSkills Daily** — Fail Fast, Learn Faster
