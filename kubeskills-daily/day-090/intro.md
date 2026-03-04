# Multi-Container Pod Sidecar Failure Debugging

Welcome to this lab on multi-container pod failures. You have been called in to debug a production pod that keeps restarting. The application team insists their main container code is fine, but the pod restarts every few minutes. Your job is to identify that the culprit is a misconfigured sidecar container, fix it, and restore stable operation. This is a common real-world failure pattern in environments using service meshes or centralized log collection.

> **Day 90 of KubeSkills Daily** — Fail Fast, Learn Faster
