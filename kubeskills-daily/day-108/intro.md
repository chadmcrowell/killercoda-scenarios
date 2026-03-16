# ServiceAccount Token Mounting and Credential Exposure

Welcome to this lab on service account token exposure. Kubernetes mounts a service account token into every pod by default, which creates unnecessary risk when those pods have no reason to talk to the API server. In this lab you will audit running workloads for unnecessary token mounts, understand the security implications, and apply the correct configuration to disable token mounting where it is not needed.

> **Day 108 of KubeSkills Daily** — Fail Fast, Learn Faster
