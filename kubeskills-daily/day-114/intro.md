# Taints and Tolerations Scheduling Failures

Welcome to the Taints and Tolerations lab. Your cluster has dedicated nodes for specific workload types but several deployments are stuck in pending state even though the nodes appear to have available capacity. Other pods that were running have suddenly been evicted. The root cause is a mismatch between the taints on your nodes and the tolerations declared in your pod specifications. Your job is to find and fix these mismatches.

> **Day 114 of KubeSkills Daily** — Fail Fast, Learn Faster
