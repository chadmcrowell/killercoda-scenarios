# Control Plane Leader Election - Diagnosing Leadership Instability

Kubernetes runs multiple replicas of its control plane components like the scheduler and controller manager in high-availability setups, but only one instance should be active at a time. Leader election using Kubernetes Lease objects ensures this coordination. When election is misconfigured or the lease renewal process is disrupted, the control plane can experience split-brain conditions that cause erratic behavior. In this lab you will explore how leader election works and what breaks when it goes wrong.

> **Day 173 of KubeSkills Daily** — Fail Fast, Learn Faster
