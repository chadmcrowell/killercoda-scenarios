# Pod Anti-Affinity Scaling Deadlock

Pod anti-affinity is a powerful tool for spreading workloads across failure domains, but required anti-affinity with a hostname topology key creates an invisible ceiling equal to your node count. In this lab you will identify why a deployment is stuck in a partial Pending state and fix the anti-affinity configuration to restore scaling.

> **Day 119 of KubeSkills Daily** — Fail Fast, Learn Faster
