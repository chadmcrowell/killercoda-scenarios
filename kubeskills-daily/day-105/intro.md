# Taints and Tolerations Scheduling Failures

Welcome to this lab on taint and toleration misconfigurations. Taints are applied to nodes to repel pods that do not explicitly tolerate them. This is useful for dedicating hardware to specific workloads, but when tolerations are absent or wrong the node stays empty while your pods pile up elsewhere. In this lab you will diagnose a scheduling imbalance caused by a missing toleration and apply the fix.

> **Day 105 of KubeSkills Daily** — Fail Fast, Learn Faster
