# Node Affinity Scheduling Failures

Welcome to this lab on node affinity misconfigurations. Node affinity allows you to constrain which nodes your pods can be scheduled on based on node labels. When required affinity rules reference labels that do not exist, the scheduler cannot place the pod anywhere and it stays Pending indefinitely. In this lab you will find a broken deployment, diagnose the affinity problem, and fix it.

> **Day 104 of KubeSkills Daily** — Fail Fast, Learn Faster
