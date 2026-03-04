# Node Certificate Expiration Recovery Lab

Welcome to this certificate management and cluster recovery lab. A worker node in your cluster has suddenly transitioned to NotReady status. The operations team has checked the node and confirmed that the virtual machine is running and all the containers are still operating, but the Kubernetes control plane cannot communicate with it. Your job is to determine that the root cause is an expired kubelet client certificate, understand the implications for running workloads, and restore authenticated communication between the node and the API server.

> **Day 96 of KubeSkills Daily** — Fail Fast, Learn Faster
