# Kubernetes Garbage Collection - Cleaning Up Orphaned Resources

Kubernetes automatically manages the lifecycle of dependent resources through owner references and a garbage collection controller. When this system works correctly, deleting a Deployment also removes its ReplicaSets and Pods. When it breaks down or is bypassed, resources pile up as orphans. In this lab you will inspect owner references, observe how deletion propagation modes work, and clean up a cluster that has accumulated orphaned resources over time.

> **Day 170 of KubeSkills Daily** — Fail Fast, Learn Faster
