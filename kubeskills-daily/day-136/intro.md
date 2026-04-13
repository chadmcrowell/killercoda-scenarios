# Cluster Autoscaler vs Pod Disruption Budgets - The Scale-Down Deadlock

The platform team has reported that several nodes have been underutilized for days but the cluster autoscaler is not removing them. Cloud costs are rising and the finance team is asking questions. Your job is to find out why the autoscaler is stuck, identify the conflicting configuration, and fix it without compromising application availability.

> **Day 136 of KubeSkills Daily** — Fail Fast, Learn Faster
