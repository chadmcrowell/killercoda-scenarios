# kube-proxy and Service Networking - Fixing Broken Routing Rules

Every Kubernetes node runs kube-proxy, which is responsible for making service cluster IPs actually work. It does this by writing network rules that redirect traffic destined for a service IP to one of the healthy backing pods. When these rules are missing or incorrect, services become reachable in theory but broken in practice. In this lab you will diagnose a node-local service routing failure and restore connectivity by fixing the kube-proxy configuration.

> **Day 172 of KubeSkills Daily** — Fail Fast, Learn Faster
